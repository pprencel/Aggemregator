class JewelsController < ApplicationController
  before_action :set_jewel, only: %i[ show edit update destroy ]

  # GET /jewels or /jewels.json
  def index
    @jewels = Jewel.all
  end

  def autocomplete
    @tags = []
    if params[:q].present?
      @tags = Jewel.search_by_name(params[:q])
      @tags = @tags.limit(3).pluck(:name)
    end
    render layout: false
  end

  # GET /jewels/1 or /jewels/1.json
  def show
  end

  # GET /jewels/new
  def new
    @jewel = Jewel.new
  end

  # GET /jewels/1/edit
  def edit
  end

  # POST /jewels or /jewels.json
  def create
    @jewel = Jewel.new(jewel_params)

    respond_to do |format|
      if @jewel.save
        format.html { redirect_to jewel_url(@jewel), notice: "Jewel was successfully created." }
        format.json { render :show, status: :created, location: @jewel }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @jewel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jewels/1 or /jewels/1.json
  def update
    respond_to do |format|
      if @jewel.update(jewel_params)
        format.html { redirect_to jewel_url(@jewel), notice: "Jewel was successfully updated." }
        format.json { render :show, status: :ok, location: @jewel }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @jewel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jewels/1 or /jewels/1.json
  def destroy
    @jewel.destroy

    respond_to do |format|
      format.html { redirect_to jewels_url, notice: "Jewel was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jewel
      @jewel = Jewel.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def jewel_params
      params.require(:jewel).permit(:name)
    end
end
