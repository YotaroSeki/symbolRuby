# encoding: utf-8

LAMBDA_START = '__="_"=~/$/;_=__+__;->(&___){___["", ""<<((_+__)*_*_*_+__)*_*_+__<<((((_+__)*_+__)*_*_+__)*_+__)*_<<(_+__)*_*_*_*_*_+__<<(((_+__)*_*_+__)*_+__)*_*_,"#{""'.freeze
LAMBDA_END = '}"]}[&:"#{""<<(((_+__)*_+__)*_*_*_+__)*_+__<<((_+__)*_*_*_+__)*_*_+__<<(((_+__)*_*_+__)*_+__)*_*_+_<<((_+__)*_*_*_+__)*_*_}"]'.freeze

class Converter
  def initialize(filename)
    @filename = filename.dup
    @body_of_program = ''
    @converted_program = ''
  end

  def run
    read_file
    convert
    write_file
  end

  private

  def char_to_symbol(char)
    char_num = char.ord
    @converted_program += '<<'
    while char_num != 0
      if char_num.odd?
        @converted_program += '__'
        char_num -= 1
      else
        @converted_program += '_'
        char_num -= 2
      end

      @converted_program += '+' if char_num != 0
    end
  end

  def convert
    @converted_program += LAMBDA_START
    @body_of_program.chars do |char|
      char_to_symbol(char)
    end
    @converted_program += LAMBDA_END
  end

  def is_single_quote?(char)
    return true if char == "'"
    false
  end

  def is_symbol?(char)
    return true unless char =~ /[A-Za-z0-9]/
    false
  end

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

  def write_file
    @filename.insert(-4, 'Sym')
    f = File.open(@filename, 'w') do |file|
      file.print @converted_program
    end
  rescue => e
    p e
  end

  def is_not_ruby_file?
    return true unless @filename =~ /.+\.rb/
    false
  end
end

converter = Converter.new(ARGV[0])
converter.run
