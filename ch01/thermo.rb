# frozen_string_literal: true
require 'rubygems'
require 'bundler/setup'

require 'cli/ui'

CLI::UI::StdoutRouter.enable

target_temp = 145

def wrap(str, max_length = 75)
  return str if str.length < max_length

  str.split('').each_slice(max_length).to_a.map { |x| x.join('') }.join("\n")
end

def fmt_temps(output)
  output.map { |temp| "#{temp.round(1)}°F" }.join(', ')
end

CLI::UI::Frame.open("{{bold: Cooking to #{target_temp}°F}}", color: :green) do
  sg = CLI::UI::SpinGroup.new
  output = []
  sg.add('Looking for Thermometer') { sleep(rand) }
  sg.wait
  sg.add('Testing Connection') { sleep(rand) }
  sg.wait
  sg.add('Measuring Temperature: ') { sleep(0) }
  sg.add('') do |spinner|
    loop do
      if output.empty?
        output.push(75)
      else
        output.push(output.last + rand(6.5..9.5))
      end
      spinner.update_title(fmt_temps(output))
      sleep(rand)
      break unless output.last < target_temp
    end
  end
  sg.wait
  puts CLI::UI.fmt '{{*}} Target Temperature Reached!'
  # puts CLI::UI.fmt "[ #{fmt_temps(output)} ]"
end
