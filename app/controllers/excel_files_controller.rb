class ExcelFilesController < ApplicationController
  before_action :set_excel_file, only: [:show, :edit, :update, :destroy]

  def index
    @excel_files = ExcelFile.all
  end

  def new
    @excel_file = ExcelFile.new
  end

  def create
    @excel_file = current_user.excel_files.new(excel_file_params)
    if @excel_file.save
      redirect_to @excel_file, notice: "Excel guardado exitosamente."
    else
      render :new
    end
  end

  def updates
  end

  def destroy
    @excel_file.destroy
    redirect_to root_path, notice: "Excel eliminado exitosamente."
  end

  def show
  end

  def edit
  end

  private
  
  def excel_file_params
    params.require(:excel_file).permit(:school, :rbd, :file)
  end

  def set_excel_file
    @excel_file = ExcelFile.find(params[:id])
  end
end

