class BlastsController < ApplicationController
  before_action :set_blast, only: [:show, :edit, :update, :destroy]

  # GET /blasts
  # GET /blasts.json
  def index
    @blasts = Blast.all
  end

  # GET /blasts/1
  # GET /blasts/1.json
  def show
  end

  # GET /blasts/new
  def new
    @blast = Blast.new
  end

  # GET /blasts/1/edit
  def edit
  end

  # POST /blasts
  # POST /blasts.json
  def create
    @blast = Blast.new(blast_params)

    respond_to do |format|
      if @blast.save
        #Blast.blast
        format.html { redirect_to @blast, notice: 'Blast was successfully created.' }
        format.json { render :show, status: :created, location: @blast }
      else
        format.html { render :new }
        format.json { render json: @blast.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blasts/1
  # PATCH/PUT /blasts/1.json
  def update
    respond_to do |format|
      if @blast.update(blast_params)
        format.html { redirect_to @blast, notice: 'Blast was successfully updated.' }
        format.json { render :show, status: :ok, location: @blast }
      else
        format.html { render :edit }
        format.json { render json: @blast.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blasts/1
  # DELETE /blasts/1.json
  def destroy
    @blast.destroy
    respond_to do |format|
      format.html { redirect_to blasts_url, notice: 'Blast was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blast
      @blast = Blast.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blast_params
      params.require(:blast).permit(:text, :reach)
    end
end
