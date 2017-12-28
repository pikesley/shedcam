module Shedcam
  describe App do
    it 'says ShedCam' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to match /Shedcam/
    end
  end
end
