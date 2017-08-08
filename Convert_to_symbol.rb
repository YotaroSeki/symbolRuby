class Converter
  def initialize(filename)
    @filename = filename
    @body_of_program = ''
  end

  def convert
    read_file
  end

  private

  def read_file
    if is_not_ruby_file?
      STDERR.puts 'Input file is not Ruby!!!'
      exit
    end

    begin
      f = File.open(@filename, mode = 'rt:BOM|utf-8') do |f|
        @body_of_program = f.read
      end
    rescue => e
      p e
    end
  end

  def is_not_ruby_file?
    return true unless @filename =~ /.+\.rb/
    false
  end
end

converter = Converter.new(ARGV[0])
converter.convert
