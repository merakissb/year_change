class ExcelFilesController < ApplicationController
  def index
    @excel_files = ExcelFile.all
  end

  def new
    @excel_file = ExcelFile.new
  end

  def create
  end

  def update
  end

  def destroy
  end

  def show
  end

  def edit
  end
end

