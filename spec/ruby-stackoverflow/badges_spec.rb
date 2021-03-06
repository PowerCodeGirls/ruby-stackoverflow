require 'spec_helper'
module RubyStackoverflow
  describe Client::BadgesHelper do
    before(:each) do
      configure_stackoverflow
      @user_basic_url= 'badges/'
    end

    it 'should find badges' do
      VCR.use_cassette('badges') do
        response = RubyStackoverflow.badges({min: 'gold', max: 'bronze', sort: 'rank'})
        expect(response.data.is_a?(Array)).to be_truthy
        expect(response.data.count).to eq(30)
        expect(response.data.first.name).to eq('Teacher')
      end
    end

    it 'should find badges by ids' do
      VCR.use_cassette('badges_by_ids') do
        response = RubyStackoverflow.badges_by_ids([1, 2], {min: 'gold', max: 'bronze', sort: 'rank'})

        expect(response.data.is_a?(Array)).to be_truthy
        expect(response.data.count).to eq(2)
        expect(response.data.first.name).to eq('Teacher')
      end
    end

    it 'should find badges by name' do
      VCR.use_cassette('badges_by_name') do
        response = RubyStackoverflow.badges_by_name({inname: 'teacher',min: 'gold', max: 'bronze', sort: 'rank'})

        expect(response.data.is_a?(Array)).to be_truthy
        expect(response.data.count).to eq(1)
        expect(response.data.first.name).to eq('Teacher')
      end
    end

    it 'should find recently added badges' do
      VCR.use_cassette('badges_by_recipients') do
        response = RubyStackoverflow.badges_between_dates({page: 1, pagesize: 10})

        expect(response.data.is_a?(Array)).to be_truthy
        expect(response.data.count).to eq(10)
        expect(response.data.first.name).to eq('Editor')
      end
    end

    it 'should find recently added badges by ids' do
      VCR.use_cassette('badges_by_recipients_by_ids') do
        response = RubyStackoverflow.badges_between_dates_by_ids([146, 20],{page: 1, pagesize: 10})

        expect(response.data.is_a?(Array)).to be_truthy
        expect(response.data.count).to eq(10)
        expect(response.data.first.name).to eq('Nice Question')
      end
    end

    it 'should find badges by tags' do
      VCR.use_cassette('badges_by_tags') do
        response = RubyStackoverflow.badges_by_tags({inname: 'unity',min: 'gold', max: 'bronze', sort: 'rank'})

        expect(response.data.is_a?(Array)).to be_truthy
        expect(response.data.count).to eq(2)
        expect(response.data.first.name).to eq('unity')
      end
    end
  end
end
