module Shedcam
  describe 'rake helpers' do
    context 'daylight data' do
      before :each do
        FileUtils.mkdir_p 'config'
        FileUtils.copy File.join(File.dirname(__FILE__), '../fixtures/daylight.times'), 'config'
      end

      it 'knows it is daylight at midday' do
        Timecop.freeze DateTime.parse '2017-12-30T12:00:00' do
          expect(Shedcam.daylight DateTime.now).to be true
        end
      end

      it 'knows it is not daylight at midnight' do
        Timecop.freeze DateTime.parse '2017-12-30T00:00:00' do
          expect(Shedcam.daylight DateTime.now).to be false
        end
      end

      it 'checks only the time, not the date' do
        Timecop.freeze DateTime.parse '2018-01-13T12:00:00' do
          expect(Shedcam.daylight DateTime.now).to be true
        end
      end
    end

    it 'generates a filename' do
      Timecop.freeze DateTime.parse '2017-12-30T12:31:00' do
        expect(Shedcam.jpg_name DateTime.now).to eq '20171230T123100.jpg'
      end
    end

    it 'generates a path' do
      Timecop.freeze DateTime.parse '2017-12-30T12:31:00' do
        expect(Shedcam.jpg_path DateTime.now).to eq '/2017/12/30'
      end
    end

    context 'raspistill flags' do
      it 'assembles the raspistill_flags' do
        CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), '../fixtures/raspistill_config.yml'))
        expect(Shedcam.raspistill_flags).to eq ' -vf -hf --awb cloud --metering spot'
      end

      it 'copes with bad config' do
        CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), '../fixtures/raspistill_config_bad.yml'))
        expect(Shedcam.raspistill_flags).to eq ''
      end
    end
  end
end
