module Common

  def log(lvl,logs)
    lvldef = {
      :info => "INFO",
      :debug => "DEBUG",
      :warn => "WARNING",
      :error => "ERROR",
      :fatal => "FATAL"
    }
    t = Time.now
    puts "#{t.strftime("%Y%m%d_%H:%M:%S")} #{lvldef[lvl]} #{logs}"
  end

  def sh(script)
    ret = system(script)
    if (ret == true)
      log(:debug,"exec shell \"#{script}\",success")
      return 0
    else
      log(:error,"exec shell \"#{script}\",command exit with fail")
      return 1
    end
  end

  def trysh(try_time,script)
    try_time.times do
      return 0 if sh(script)
    end
    return 1
  end

  def randstring( len )
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    str = ""
    1.upto(len) { |i| str << chars[rand(chars.size-1)] }
    return str
  end

end
