module Common

  def log(lvl,logs)
    lvldef = {
      :info => "INFO",
      :debug => "DEBUG",
      :warn => "WARNING",
      :error => "ERROR",
      :fatal => "FATAL"
    }
    puts "#{lvldef[lvl]} #{logs}"
  end

  def sh(script)
    begin 
      ret = system(script)
      log(:debug,"exec shell")
    rescue => e
      log(:error,"command exit with fail(#{ret}),#{e}")
    end
  end

end
