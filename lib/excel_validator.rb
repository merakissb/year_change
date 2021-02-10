module ExcelValidator
  def self.process(file)
    xlsx = Roo::Spreadsheet.open(file.service_url, extension: :xlsx)
    sheet = xlsx.sheet(0)
    set_headers(sheet)
    validate_guardians(sheet)
  end

  private_class_method def self.set_headers(sheet)
    @headers = {}
    sheet.row(1).each_with_index {|header,i|
      @headers[header] = i
    }
  end

  private_class_method def self.validate_guardians(sheet)
    @first_guardian_phones = sheet.column(@headers["Celular Apoderado"] + 1)
    @second_guardian_phones = sheet.column(@headers["Celular Apoderado Secundario"] + 1) 

    @first_guardian_phones.each_with_index do |first_guardian_phone, index|
      next if index.zero?

      second_guardian_phone = sheet.cell(index + 1, @headers["Celular Apoderado Secundario"] + 1)
      if first_guardian_phone == second_guardian_phone and first_guardian_phone != nil
        
        
      end
    end

    #puts "#{@first_guardian_phones} - #{@second_guardian_phones}"
  end

end