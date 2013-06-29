class FundraiserType < ActiveRecord::Base
  include CommonNamedScopes

  EASY = 1
  MEDIUM = 2
  HARD = 3
  EASY_TEXT = "Easy"
  MEDIUM_TEXT = "Medium"
  HARD_TEXT = "Hard"

  DIFFICULTIES = [EASY, MEDIUM, HARD]

  DIFFICULTY_SET = [[ EASY_TEXT, EASY ],
                    [ MEDIUM_TEXT, MEDIUM ],
                    [ HARD_TEXT, HARD ]]


  has_one_unified_attachment    :picture
  has_many_unified_attachments  :associated_files
  has_many                      :fundraiser_type_experiences
  has_many                      :fundraiser_tag_associations
  has_many                      :fundraiser_tags, :through => :fundraiser_tag_associations
  has_many                      :project_events

  named_scope :most_popular,
              :joins  => "LEFT JOIN project_events ON fundraiser_types.id = project_events.fundraiser_type_id",
              :select => "fundraiser_types.*, count(project_events.id) as project_event_count",
              :conditions => "active = true",
              :order  => "project_event_count DESC",
              :group  => "fundraiser_types.id"

  named_scope :active,
              :conditions => "active = true"

  accepts_nested_attributes_for :picture

  validates_presence_of   :name
  validates_inclusion_of  :difficulty, :in => DIFFICULTIES

  #this possibly needs to be hardcoded, or other info need to come available
  def self.most_successful
    FundraiserType.active.random
    #FundraiserType.find(:first,:conditions => 'active=true')
  end

  def self.other_fundraisers_you_might_like
    FundraiserType.active.random
  end

  def self.determine_perfect_fundraisers(options = { })
    difficulty = difficulty_from_number_of_fundraisers(options[:number_of_fundraisers])

    options[:fundraiser_tag_ids].reject!(&:blank?)
    tag_sql = options[:fundraiser_tag_ids].empty? ? "" :
      " AND fundraiser_tags.id IN (#{options[:fundraiser_tag_ids].join(',')})"

    goal_id = options[:fundraising_goal_range_id].to_i
    goal_sql = ""
    if(goal_id > 0)
      range = FundraisingGoalRange.find(goal_id)
      if(range.max_value)
        goal_sql += " AND fundraiser_types.minimum_typical_amount_raised_in_cents <= #{range.max_value}"
      end

      if(range.min_value)
        goal_sql += " AND fundraiser_types.maximum_typical_amount_raised_in_cents >= #{range.min_value}"
      end
    end

    FundraiserType.scoped(
                          :include => :fundraiser_tags,
                          :conditions => "fundraiser_types.difficulty = #{difficulty}#{goal_sql}#{tag_sql},active=true"
                          )
  end

  def self.difficulty_from_number_of_fundraisers(number)
    case number.to_i
      when 0 then EASY
      when 1 then EASY
      when 2 then MEDIUM
      when 3 then MEDIUM
      else HARD
    end
  end

  def self.difficulty_text(difficulty)
    case difficulty.to_i
      when EASY then EASY_TEXT
      when MEDIUM then MEDIUM_TEXT
      when HARD then HARD_TEXT
      else ""
    end
  end

  def fundraising_range
    "$#{self.minimum_typical_amount_raised_in_dollars} - $#{self.maximum_typical_amount_raised_in_dollars}"
  end

  def minimum_typical_amount_raised_in_dollars
    MoneyConversion.cents_to_dollars(self.minimum_typical_amount_raised_in_cents)
  end

  def minimum_typical_amount_raised_in_dollars=(value)
    self.minimum_typical_amount_raised_in_cents = MoneyConversion.dollars_to_cents(value)
  end

  def maximum_typical_amount_raised_in_dollars
    MoneyConversion.cents_to_dollars(self.maximum_typical_amount_raised_in_cents)
  end

  def maximum_typical_amount_raised_in_dollars=(value)
    self.maximum_typical_amount_raised_in_cents = MoneyConversion.dollars_to_cents(value)
  end

  def good_for_tags
    self.fundraiser_tags.map{ |t| t.name }.join(', ')
  end

  def file_count
    self.associated_files.size
  end

  def cp_testimonial_count
    self.fundraiser_type_experiences.size
  end

  def tags
    self.good_for_tags
  end

  def tags=(value)
    self.fundraiser_tag_associations.destroy_all
    value.split(',').map(&:strip).map(&:downcase).reject(&:blank?).each do |tag|
      fundraiser_tag = FundraiserTag.find_or_create_by_name(tag)
      self.fundraiser_tags << fundraiser_tag unless self.fundraiser_tags.include?(fundraiser_tag)
    end
  end

  def difficulty_text
    FundraiserType.difficulty_text(self.difficulty)
  end
end

