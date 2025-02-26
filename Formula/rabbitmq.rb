class Rabbitmq < Formula
  desc "Messaging broker"
  homepage "https://www.rabbitmq.com"
  url "https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.8.3/rabbitmq-server-generic-unix-3.8.3.tar.xz"
  sha256 "5a2739ed1dba77f88316b4c63393d8037fc4acf51881ba922470453e891875b6"

  bottle :unneeded

  depends_on "erlang"

  uses_from_macos "unzip" => :build

  def install
    # Install the base files
    prefix.install Dir["*"]

    # Setup the lib files
    (var/"lib/rabbitmq").mkpath
    (var/"log/rabbitmq").mkpath

    # Correct SYS_PREFIX for things like rabbitmq-plugins
    erlang = Formula["erlang"]
    inreplace sbin/"rabbitmq-defaults" do |s|
      s.gsub! "SYS_PREFIX=${RABBITMQ_HOME}", "SYS_PREFIX=#{HOMEBREW_PREFIX}"
      s.gsub! /^ERL_DIR=$/, "ERL_DIR=#{erlang.opt_bin}/"
      s.gsub! "CLEAN_BOOT_FILE=start_clean", "CLEAN_BOOT_FILE=#{erlang.opt_lib/"erlang/bin/start_clean"}"
      s.gsub! "SASL_BOOT_FILE=start_sasl", "SASL_BOOT_FILE=#{erlang.opt_lib/"erlang/bin/start_clean"}"
    end

    # Set RABBITMQ_HOME in rabbitmq-env
    inreplace sbin/"rabbitmq-env",
              'RABBITMQ_HOME="$(rmq_realpath "${RABBITMQ_SCRIPTS_DIR}/..")"',
              "RABBITMQ_HOME=#{prefix}"

    # Create the rabbitmq-env.conf file
    rabbitmq_env_conf = etc/"rabbitmq/rabbitmq-env.conf"
    rabbitmq_env_conf.write rabbitmq_env unless rabbitmq_env_conf.exist?

    # Enable plugins - management web UI; STOMP, MQTT, AMQP 1.0 protocols
    enabled_plugins_path = etc/"rabbitmq/enabled_plugins"
    unless enabled_plugins_path.exist?
      enabled_plugins_path.write "[rabbitmq_management,rabbitmq_stomp,rabbitmq_amqp1_0,rabbitmq_mqtt]."
    end

    # Extract rabbitmqadmin and install to sbin
    # use it to generate, then install the bash completion file
    system (OS.mac? ? "/usr/bin/unzip" : "unzip"), "-qq", "-j",
           "#{prefix}/plugins/rabbitmq_management-#{version}.ez",
           "rabbitmq_management-#{version}/priv/www/cli/rabbitmqadmin"

    sbin.install "rabbitmqadmin"
    (sbin/"rabbitmqadmin").chmod 0755
    (bash_completion/"rabbitmqadmin.bash").write Utils.safe_popen_read("#{sbin}/rabbitmqadmin", "--bash-completion")
  end

  def caveats
    <<~EOS
      Management Plugin enabled by default at http://localhost:15672
    EOS
  end

  def rabbitmq_env
    <<~EOS
      CONFIG_FILE=#{etc}/rabbitmq/rabbitmq
      NODE_IP_ADDRESS=127.0.0.1
      NODENAME=rabbit@localhost
      RABBITMQ_LOG_BASE=#{var}/log/rabbitmq
    EOS
  end

  plist_options :manual => "rabbitmq-server"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>Program</key>
          <string>#{opt_sbin}/rabbitmq-server</string>
          <key>RunAtLoad</key>
          <true/>
          <key>EnvironmentVariables</key>
          <dict>
            <!-- need erl in the path -->
            <key>PATH</key>
            <string>#{HOMEBREW_PREFIX}/sbin:/usr/sbin:/usr/bin:/bin:#{HOMEBREW_PREFIX}/bin</string>
            <!-- specify the path to the rabbitmq-env.conf file -->
            <key>CONF_ENV_FILE</key>
            <string>#{etc}/rabbitmq/rabbitmq-env.conf</string>
          </dict>
          <key>StandardErrorPath</key>
          <string>#{var}/log/rabbitmq/std_error.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/rabbitmq/std_out.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    ENV["RABBITMQ_MNESIA_BASE"] = testpath/"var/lib/rabbitmq/mnesia"
    system sbin/"rabbitmq-server", "-detached"
    sleep 5
    system sbin/"rabbitmqctl", "status"
    system sbin/"rabbitmqctl", "stop"
  end
end
