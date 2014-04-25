module Psp
  module Ascii
    module_function

    def red(text)
      "\e[0;31m#{text}\e[0m"
    end

    def green(text)
      "\e[0;32m#{text}\e[0m"
    end

    def yellow(text)
      "\e[0;33m#{text}\e[0m"
    end

    def blue(text)
      "\e[0;34m#{text}\e[0m"
    end

    def magenta(text)
      "\e[0;35m#{text}\e[0m"
    end
  end
end
