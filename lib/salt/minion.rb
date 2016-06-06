# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module Salt
  class Minion
    attr_reader :node

    def initialize(node, args)
      @node = node
      @args = args
    end

    def id
      @args['id']
    end

    def host
      @args['host']
    end

    def domain
      @args['domain']
    end

    def os
      @args['os']
    end

    def os_release
      @args['osrelease']
    end

    def os_name
      @args['osfullname']
    end

    def os_family
      @args['os_family']
    end

    def os_architecture
      @args['osarch']
    end

    def cpus
      @args['num_cpus']
    end

    def memory
      @args['mem_total']
    end

    def primary_ip
      @args['master']
    end

    def ip_interfaces
      @args['ip_interfaces']
    end

    def hwaddr_interfaces
      @args['hwaddr_interfaces']
    end

    def ipv4_addresses
      @args['ipv4']
    end

    def ipv6_addresses
      @args['ipv6']
    end

    def hypervisor
      @args['virtual']
    end

    def cpu_model
      @args['cpu_model']
    end

    def cpu_flags
      @args['cpu_flags']
    end

    def zmq_version
      @args['zmqversion']
    end

    def kernel
      @args['kernel']
    end

    def kernel_release
      @args['kernelrelease']
    end

    def python_path
      @args['pythonpath']
    end

    def shell
      @args['shell']
    end

    def salt_version
      @args['saltversioninfo']
    end

    def server_id
      @args['server_id']
    end
  end
end
