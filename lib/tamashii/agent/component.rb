require 'tamashii/agent/common'
require 'tamashii/agent/event'


module Tamashii
  module Agent
    class Component
      include Common::Loggable

      def initialize(master)
        @master = master
        @event_queue = Queue.new
      end

      def send_event(event)
        @event_queue.push(event)
      end

      def check_new_event(non_block = false)
        @event_queue.pop(non_block)
      rescue ThreadError => e
        nil
      end
      
      def handle_new_event(non_block = false)
        if ev = check_new_event(non_block)
          process_event(ev)
        end
        ev
      end

      def process_event(event)
        logger.debug "Got event: #{event.type}, #{event.body}"
      end

      # worker
      def run
        @worker_thr = Thread.start { run_worker_loop }
      end

      def run!
        run_worker_loop
      end
      
      def stop
        logger.info "Stopping component"
        stop_threads
        clean_up
      end

      def stop_threads
        @worker_thr.exit if @worker_thr
        @worker_thr = nil
      end

      def clean_up
      end

      def run_worker_loop
        worker_loop
      end

      # a default implementation
      def worker_loop
        loop do
          if !handle_new_event
            logger.error "Thread error. Worker loop terminated"
            break
          end
        end
      end
    end
  end
end
