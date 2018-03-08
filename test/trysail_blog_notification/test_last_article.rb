module TrySailBlogNotificationTest
  class TestLastArticle < TestCase

    def initialize(*args)
      super(*args)

      @title = 'Test title'
      @url = 'https://hiroto-k.net/'
      @last_update = '2018-02-08'
    end

    def test_to_h
      last_article = TrySailBlogNotification::LastArticle.new(@title, @url, @last_update)

      assert_instance_of(Hash, last_article.to_h)
    end

    def test_hash_access_string
      last_article = TrySailBlogNotification::LastArticle.new(@title, @url, @last_update)

      assert_equal(@title, last_article['title'])
      assert_equal(@url, last_article['url'])
      assert_equal(@last_update, last_article['last_update'])
    end

    def test_hash_access_symbol
      last_article = TrySailBlogNotification::LastArticle.new(@title, @url, @last_update)

      assert_equal(@title, last_article[:title])
      assert_equal(@url, last_article[:url])
      assert_equal(@last_update, last_article[:last_update])
    end

    def test_hash_access_error_string
      last_article = TrySailBlogNotification::LastArticle.new(@title, @url, @last_update)

      assert_nil(last_article['example'])
    end

    def test_hash_access_error_symbol
      last_article = TrySailBlogNotification::LastArticle.new(@title, @url, @last_update)

      assert_nil(last_article[:example])
    end


  end
end