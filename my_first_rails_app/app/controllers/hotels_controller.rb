class HotelsController < ApplicationController
  before_action :set_trip, only: %i[ new create ]
  before_action :set_hotel, only: %i[ show edit update destroy ]

  # GET /hotels or /hotels.json
  def index
    @hotels = Hotel.all.includes(:trip).order(created_at: :desc)
  end

  # GET /hotels/1 or /hotels/1.json
  def show
  end

  # GET /trips/:trip_id/hotels/new
  def new
    @hotel = @trip.hotels.build
  end

  # GET /hotels/1/edit
  def edit
  end

  # POST /trips/:trip_id/hotels or /hotels.json
  def create
    @hotel = @trip.hotels.build(hotel_params)

    respond_to do |format|
      if @hotel.save
        format.html { redirect_to @trip, notice: "Hotel was successfully added to your trip." }
        format.json { render :show, status: :created, location: @hotel }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @hotel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hotels/1 or /hotels/1.json
  def update
    respond_to do |format|
      if @hotel.update(hotel_params)
        format.html { redirect_to @hotel.trip, notice: "Hotel was successfully updated." }
        format.json { render :show, status: :ok, location: @hotel }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @hotel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hotels/1 or /hotels/1.json
  def destroy
    trip = @hotel.trip
    @hotel.destroy!

    respond_to do |format|
      format.html { redirect_to trip, notice: "Hotel was successfully removed from your trip." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = Trip.find(params[:trip_id])
    end

    def set_hotel
      @hotel = Hotel.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def hotel_params
      params.require(:hotel).permit(:name, :url, :price, :currency)
    end
end
