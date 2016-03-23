class LogsController < ApplicationController
  before_action :set_log, only: [:show, :destroy]

  # GET /logs
  # GET /logs.json
  def index
    @logs = Log.all
  end

  def show
  end

  def destroy
    @log.destroy
    respond_to do |format|
      format.html { redirect_to logs_url, notice: 'Log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_log
      @log = Log.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def log_params
      params.require(:log).permit(:channel_id, :message_id, :delivery_time, :scheduled)
    end
end
