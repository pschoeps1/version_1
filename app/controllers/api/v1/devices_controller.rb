class Api::V1::DevicesController < ApplicationController

	def create
		device = Device.new
		#device.user_id = user_id
		#device.token = device_id
		device.save
	end
end