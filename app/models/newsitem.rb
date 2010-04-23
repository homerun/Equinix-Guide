class Newsitem < ActiveRecord::Base
  belongs_to :user
  has_many :newscomments, :dependent => :destroy
  has_many :newsratings, :dependent => :destroy
  
  has_many :nptags, :class_name => 'News2np', :dependent => :destroy
  has_many :nps, :class_name => 'Networkprovider', :through => :nptags
  
  has_many :poitags, :class_name => 'News2poi', :dependent => :destroy
  has_many :pois, :class_name => 'Pointsofinterest', :through => :poitags
  
  has_many :regiontags, :class_name => 'News2region', :dependent => :destroy
  has_many :regions, :class_name => 'Equinixregion', :through => :regiontags
  
  has_many :markettags, :class_name => 'News2market', :dependent => :destroy
  has_many :markets, :through => :markettags
  
  has_many :ntpownertags, :class_name => 'News2ntpowner', :dependent => :destroy
  has_many :ntpOwners, :class_name => 'Networktermptowner', :through => :ntpownertags
  
  has_many :othertag_newsitems, :dependent => :destroy
  has_many :othertags, :through => :othertag_newsitems
  
  def rated_by_user?(user_id)
    return nil if newsratings == nil
    newsratings.each do |rating|
      return rating.rating if rating.user_id == user_id
    end
    return nil
  end
  
  def positive_ratings_count
    return 0 if newsratings == nil
    count = 0
    newsratings.each do |rating|
      count += 1 if rating.rating == true
    end
    return count
  end
  
  def negative_ratings_count
    return 0 if newsratings == nil
    count = 0
    newsratings.each do |rating|
      count += 1 if rating.rating == false
    end
    return count
  end
  
  def net_rating
    return self.positive_ratings_count - self.negative_ratings_count
  end
  
  def total_ratings
    return 0 if newsratings == nil
    return newsratings.size
  end
  
  def point_value_old
    points = self.net_rating
    negative_points = 0.9
    negative_points = points * -1 if points < 0
    points = 1 if points <= 0
    points += 1 if self.net_rating > 0
    date_time = self.created_at
    date_time = Time.now - 99999 if date_time == nil
    return points / (((Time.now - date_time)/604800.0)*negative_points)
  end
  
  def tsValue
    begin_date = Time.parse("Jan 1, 2008")
    news_date = self.created_at
    news_date = begin_date if news_date == nil
    return news_date - begin_date
  end
  
  def yValue
    return (self.net_rating >= 0 ? 1 : -1)
  end
  
  def zValue
    return (self.net_rating > 1 ? self.net_rating : 1)
  end
  
  def point_value_hottest
    return Math.log10(self.zValue) + (self.tsValue*self.yValue)/604800.0
  end
  
  def point_value_upcoming
    return Math.log10(self.zValue) + (self.tsValue*self.yValue)/259200.0
  end
  
  def has_tag(type,id)
    tags = eval("self.#{type}tags")
    return false if tags == nil
    tags.each do |tagId|
      return true if "#{tagId}" == "#{id}"
    end
    return false
  end
  
  def print_url
    if self.url[0..6] == "http://" then
      return url
    else
      return "http://#{self.url}"
    end
  end
end