module Shedcam
  describe 'rake helpers' do
    context 'daylight data' do
      before :each do
        FileUtils.mkdir_p 'config'
        FileUtils.copy File.join(File.dirname(__FILE__), '../fixtures/daylight.times'), 'config'
      end

      it 'knows it is daylight at midday' do
        Timecop.freeze(DateTime.parse '2017-12-30T12:00:00') do
          expect(Shedcam.daylight DateTime.now).to be true
        end
      end

      it 'knows it is not daylight at midnight' do
        Timecop.freeze(DateTime.parse '2017-12-30T00:00:00') do
          expect(Shedcam.daylight DateTime.now).to be false
        end
      end
    end

    it 'generates a filename' do
      Timecop.freeze(DateTime.parse '2017-12-30T12:31:00') do
        expect(Shedcam.jpg_name DateTime.now).to eq '2017-12-30T12:31:00+00:00.jpg'
      end
    end

    it 'generates a path' do
      Timecop.freeze(DateTime.parse '2017-12-30T12:31:00') do
        expect(Shedcam.jpg_path DateTime.now).to eq '/2017/12/30'
      end
    end
  end
end
