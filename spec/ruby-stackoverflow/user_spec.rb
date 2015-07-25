require 'spec_helper'
module RubyStackoverflow
  describe Client::UserHelper do
    before(:each) do
      configure_stackoverflow
      @user_basic_url= 'users/'
    end

    it 'should find users' do
      VCR.use_cassette('users') do
        response = RubyStackoverflow.users({inname: 'andrew', sort: 'reputation'})
        
        expect(response.data.first.display_name).to eq('Andrew Russell')
        expect(response.data.first.creation_date).to eq('2010-07-15 14:14:16 UTC')
      end
    end

    it 'should get user by id' do
      VCR.use_cassette('users_by_ids') do
        stub_get(@user_basic_url+'31086').to_return(json_response('users.json'))
        response = RubyStackoverflow.users_by_ids(['31086'])

        expect(response.data.last.respond_to?(:display_name)).to be_truthy
        expect(response.data.first.display_name).to eq('Andrew')
      end
    end

    it 'should get error' do
      VCR.use_cassette('error') do
        response = RubyStackoverflow.users_by_ids(['1363236&&'])

        expect(response.data).to be_nil
        expect(response.error).not_to be_nil
        expect(response.error.error_code).to eq(404)
        expect(response.error.error_message).to eq("no method found with this name")
      end
    end

    it 'should get user answers' do
      VCR.use_cassette('users_answers') do
        response = RubyStackoverflow.users_with_answers(['31086'])

        expect(response.data.last.respond_to?(:display_name)).to be_truthy
        expect(response.data.first.display_name).to eq('Andrew')
        expect(response.data.first.answers.count).to eq(1)
        expect(response.data.first.answers.last.answer_id).to eq(56075)
        expect(response.data.first.answers.last.last_activity_date).to eq('2013-05-23 20:49:43 UTC')
      end
    end

    it 'should get user badges' do
      VCR.use_cassette('users_badges') do
        response = RubyStackoverflow.users_with_badges(['31086'],{order: 'asc'})

        expect(response.data.last.respond_to?(:display_name)).to be_truthy
        expect(response.data.first.display_name).to eq('Andrew')
        expect(response.data.first.badges.count).to eq(3)
        expect(response.data.first.badges.first.name).to eq('Student')
      end
    end

    it 'should get user comments' do
      VCR.use_cassette('users_comments') do
        response = RubyStackoverflow.users_with_comments(['3106'],{sort: 'votes'})

        expect(response.data.last.respond_to?(:display_name)).to be_truthy
        expect(response.data.count).to eq(1)
        expect(response.data.first.display_name).to eq('i_grok')
        expect(response.data.first.comments.count).to eq(9)
        expect(response.data.first.comments.first.score).to eq(1)
        expect(response.data.first.comments.first.comment_id).to eq(18273)
      end
    end

    it 'should get user replied comments' do
      VCR.use_cassette('users_replied_comments') do
        response = RubyStackoverflow.users_with_replied_comments(['1430'],'189')

        expect(response.data.last.respond_to?(:display_name)).to be_truthy
        expect(response.data.first.display_name).to eq('Josh Petrie')
        expect(response.data.first.comments.count).to eq(1)
        expect(response.data.first.comments.first.score).to eq(0)
        expect(response.data.first.comments.first.comment_id).to eq(30524)
      end
    end

    it 'should get users favorites questions' do
      VCR.use_cassette('users_favorites_questions') do
        response = RubyStackoverflow.users_with_favorites_questions(['39518', '40264'])

        expect(response.data.last.respond_to?(:display_name)).to be_truthy
        expect(response.data.first.display_name).to eq('newton1212')
        expect(response.data.first.questions.count).to eq(1)
        expect(response.data.first.questions.last.view_count).to eq(164)
      end
    end
    it 'should get questions where users are mentioned' do
      VCR.use_cassette('users_mentioned_questions') do
        response = RubyStackoverflow.users_with_mentioned_comments(['39518','40264'])

        expect(response.data.last.respond_to?(:display_name)).to be_truthy
        expect(response.data.first.display_name).to eq('Miguet Schwab')
        expect(response.data.first.comments.count).to eq(1)
        expect(response.data.first.comments.last.score).to eq(0)
      end
    end

    it 'should get users notifications' do
      VCR.use_cassette('users_notifications') do
        response = RubyStackoverflow.users_notifications('68829')

        expect(response.data.last.respond_to?(:notification_type)).to be_truthy
        expect(response.data.first.site[:site_type]).to eq('main_site')
        expect(response.data.count).to eq(1)
      end
    end
    it 'should get users unread notifications' do
      VCR.use_cassette('users_unread_notifications') do
        response = RubyStackoverflow.users_unread_notifications('57042')
        expect(response.data.last.respond_to?(:notification_type)).to be_falsey
      end
    end

    it 'should get users questions' do
      VCR.use_cassette('users_questions') do
        response = RubyStackoverflow.users_questions(['31086'])

        expect(response.data.last.respond_to?(:display_name)).to be_truthy
        expect(response.data.first.display_name).to eq('Andrew')
        expect(response.data.first.questions.count).to eq(2)
        expect(response.data.first.questions.last.view_count).to eq(556)
      end
    end

    it 'should get users featured questions' do
      VCR.use_cassette('users_featured_questions') do
        response = RubyStackoverflow.users_featured_questions(['1363236'])
        expect(response.data.is_a?(Array)).to be_truthy
      end
    end

    it 'should get users no answer questions' do
      VCR.use_cassette('users_noanswerquestions') do
        response = RubyStackoverflow.users_noanswers_questions(['34618'])

        expect(response.data).not_to be_empty
        expect(response.data.is_a?(Array)).to be_truthy
      end
    end

    it 'should get users unanswered questions' do
      VCR.use_cassette('users_unanswered_questions') do
        response = RubyStackoverflow.users_unanswered_questions(['53821'])

        expect(response.data.last.respond_to?(:display_name)).to be_truthy
        expect(response.data.first.display_name).to eq('Daniel Holst')
        expect(response.data.first.questions.count).to eq(1)
        expect(response.data.first.questions.last.view_count).to eq(54)
      end
    end

    it 'should get users unaccepted questions' do
      VCR.use_cassette('users_unaccepted_questions') do
        response = RubyStackoverflow.users_unaccepted_questions(['104510'])

        expect(response.data.last.respond_to?(:display_name)).to be_truthy
        expect(response.data.first.display_name).to eq('Greg Quinn')
        expect(response.data.first.questions.count).to eq(1)
        expect(response.data.first.questions.last.view_count).to eq(11)
      end
    end

    it 'should get users reputation' do
      VCR.use_cassette('users_reputation_questions') do
        response = RubyStackoverflow.users_reputations(['36674'])

        expect(response.data.last.respond_to?(:display_name)).to be_truthy
        expect(response.data.count).to eq(1)
        expect(response.data.first.reputations.count).to eq(3)
        expect(response.data.first.reputations.last.vote_type).to eq('up_votes')
        expect(response.data.first.reputations.last.post_type).to eq('question')
      end
    end

    it 'should get users suggested edits' do
      VCR.use_cassette('users_suggested_edits') do
        response = RubyStackoverflow.users_suggested_edits(['2698'])

        expect(response.data.count).to eq(1)
        expect(response.data.last.respond_to?(:display_name)).to be_truthy
        expect(response.data.first.display_name).to eq('doppelgreener')
        expect(response.data.first.suggested_edits.count).to eq(20)
        expect(response.data.first.suggested_edits.last.post_type).to eq('answer')
      end
    end

    it 'should get users tags' do
      VCR.use_cassette('users_tags') do
        response = RubyStackoverflow.users_tags(['31086'],{min: 1, max: 10, sort: 'popular' })

        expect(response.data.is_a?(Array)).to be_truthy
        expect(response.data.count).to eq(1)
        expect(response.data.last.respond_to?(:user_id)).to be_truthy
        expect(response.data.first.tags.count).to eq(5)
        expect(response.data.first.tags.last.name).to eq('wii')
      end
    end

    it 'should get user top answers for specific tags' do
      VCR.use_cassette('user_top_answers_with_given_tags') do
        response = RubyStackoverflow.users_top_answers_with_given_tags('31086',['ruby'])

        expect(response.data.is_a?(Array)).to be_truthy
        expect(response.data.count).to eq(1)
        expect(response.data.last.respond_to?(:user_id)).to be_truthy
        expect(response.data.first.answers.count).to eq(1)
        expect(response.data.first.answers.last.score).to eq(0)
      end
    end

    it 'should get user top questions for specific tags' do
      VCR.use_cassette('user_top_questions_with_given_tags') do
        response = RubyStackoverflow.users_top_questions_with_given_tags('31086',['wii'])

        expect(response.data.last.respond_to?(:user_id)).to be_truthy
        expect(response.data.count).to eq(1)
        expect(response.data.first.questions.count).to eq(1)
        expect(response.data.first.questions.last.score).to eq(0)
      end
    end

    it 'should Ggt the top tags (by score) a user has posted answers in' do
      VCR.use_cassette('user_top_tags_by_answers') do
        response = RubyStackoverflow.user_top_tags_by_answers('39518')
        data = response.data

        expect(data.count).to eq(1)
        expect(data.last.respond_to?(:user_id)).to be_truthy
        expect(data.first.tags.count).to eq(100)
        expect(data.first.tags.last.tag_name).to eq('3d')
      end
    end

    it 'should Ggt the top tags (by score) a user has posted questions' do
      VCR.use_cassette('user_top_tags_by_questions') do
        response = RubyStackoverflow.user_top_tags_by_questions('39518')
        data = response.data

        expect(data.count).to eq(1)
        expect(data.last.respond_to?(:user_id)).to be_truthy
        expect(data.first.tags.count).to eq(5)
        expect(data.first.tags.last.tag_name).to eq('gamepad')
      end
    end

    it 'should get user timeline' do
      VCR.use_cassette('user_timeline') do
        response = RubyStackoverflow.users_timeline(['1430'])
        data = response.data

        expect(data.count).to eq(2)
        expect(data.last.respond_to?(:user_id)).to be_truthy
        expect(data.first.posts.count).to eq(75)
        expect(data.first.posts.last.timeline_type).to eq('commented')
      end
    end

    it 'should get user write permission' do
      VCR.use_cassette('user_write_permissions') do
        response = RubyStackoverflow.user_write_permissions('68829')
        data = response.data

        expect(data.count).to eq(1)
        expect(data.last.respond_to?(:user_id)).to be_truthy
        expect(data.first.permissions.count).to eq(1)
        expect(data.first.permissions.last.can_edit).to be_truthy
      end
    end
  end
end

