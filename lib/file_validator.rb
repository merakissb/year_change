module FileValidator
  require 'open-uri'
  require 'rubyXL/convenience_methods/workbook'
  require 'rubyXL/convenience_methods/worksheet'
  OUTPUT_FILE_SHEETS_NAMES = ["Reporte Estudiantes", "CEL AP2 = AP1", "RUT INVALIDOS DE ESTUDIANTES"]

  def self.process(file)
    setup(file)
    @sheet = @input_file.worksheets[0] #first worksheet
    set_headers(@sheet)
    validate_guardians(@sheet)
    @output_file.write('output.xlsx')
    @output_file
  end

  private_class_method def self.setup(input_file) 
    url = Rails.application.routes.url_helpers.url_for(input_file)
    buffer = open(url)
    @input_file = RubyXL::Parser.parse_buffer(buffer) #workbook
    @output_file = RubyXL::Workbook.new #workbook
    OUTPUT_FILE_SHEETS_NAMES.each do |name| 
      sheet = @output_file.add_worksheet
      sheet.sheet_name = name
    end
    @output_file.worksheets.delete_at(0) #delete default sheet
  end

  private_class_method def self.set_headers(sheet)  
  @headers = {}
    sheet[0].cells.each_with_index {|header, index|
      @headers[header.value.to_s] = index
    }
  end

  private_class_method def self.validate_guardians(sheet)
    first_guardian_phones = 
    second_guardian_phones = 
    
    debugger
  end

  #private_class_method def self.find_sheet(file, sheet_name)
  #  file.workbook.worksheets.each do |worksheet|
  #    next unless worksheet.name == sheet_name

  #    return worksheet
  #  end
  #end

end