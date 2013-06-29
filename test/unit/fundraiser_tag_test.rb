require 'test_helper'

class FundraiserTagTest < ActiveSupport::TestCase

  test "there should be no fundraising goals for tags with no fundraising types" do
    tag = Factory.create(:fundraiser_tag)
    assert_equal 0, FundraiserTag.determine_fundraising_goal_ranges([tag.id]).size
  end
  
  test "there should be no fundraising goals for tags for types that have no min/max value" do
    tag = Factory.create(:fundraiser_tag)
    type = Factory.create(:fundraiser_type)
    type.fundraiser_tags << tag
    type.minimum_typical_amount_raised_in_cents = nil
    type.maximum_typical_amount_raised_in_cents = nil
    type.save
    assert_equal 0, FundraiserTag.determine_fundraising_goal_ranges([tag.id]).size
    
    type.minimum_typical_amount_raised_in_cents = 1
    type.maximum_typical_amount_raised_in_cents = nil
    type.save
    assert_equal 0, FundraiserTag.determine_fundraising_goal_ranges([tag.id]).size
    
    type.minimum_typical_amount_raised_in_cents = nil
    type.maximum_typical_amount_raised_in_cents = 1
    type.save
    assert_equal 0, FundraiserTag.determine_fundraising_goal_ranges([tag.id]).size
  end
  
  test "correct fundraising goal for a single type of a single range" do
    tag = Factory.create(:fundraiser_tag)
    type = Factory.create(:fundraiser_type)
    type.fundraiser_tags << tag

    type.minimum_typical_amount_raised_in_cents = 1000
    type.maximum_typical_amount_raised_in_cents = 20
    type.save
    ranges = FundraiserTag.determine_fundraising_goal_ranges([tag.id])
    assert_equal 1, ranges.size
    assert_equal 1, ranges[0].id
    
    type.minimum_typical_amount_raised_in_cents = 1200000
    type.maximum_typical_amount_raised_in_cents = 1300000
    type.save
    ranges = FundraiserTag.determine_fundraising_goal_ranges([tag.id])
    assert_equal 1, ranges.size
    assert_equal 3, ranges[0].id
    
    type.minimum_typical_amount_raised_in_cents = 600000
    type.maximum_typical_amount_raised_in_cents = 700000
    type.save
    ranges = FundraiserTag.determine_fundraising_goal_ranges([tag.id])
    assert_equal 1, ranges.size
    assert_equal 2, ranges[0].id
  end
  
  test "correct fundraising goal for a single type of multiple ranges" do
    tag = Factory.create(:fundraiser_tag)
    type = Factory.create(:fundraiser_type)
    type.fundraiser_tags << tag

    type.minimum_typical_amount_raised_in_cents = 1000
    type.maximum_typical_amount_raised_in_cents = 600000
    type.save
    ranges = FundraiserTag.determine_fundraising_goal_ranges([tag.id])
    assert_equal 2, ranges.size
    assert_equal 1, ranges[0].id
    assert_equal 2, ranges[1].id
    
    type.minimum_typical_amount_raised_in_cents = 600000
    type.maximum_typical_amount_raised_in_cents = 1200000
    type.save
    ranges = FundraiserTag.determine_fundraising_goal_ranges([tag.id])
    assert_equal 2, ranges.size
    assert_equal 2, ranges[0].id
    assert_equal 3, ranges[1].id
    
    type.minimum_typical_amount_raised_in_cents = 1000
    type.maximum_typical_amount_raised_in_cents = 1200000
    type.save
    ranges = FundraiserTag.determine_fundraising_goal_ranges([tag.id])
    assert_equal 3, ranges.size
    assert_equal 1, ranges[0].id
    assert_equal 2, ranges[1].id
    assert_equal 3, ranges[2].id
  end
  
  test "correct fundraising goal for multiple types of a single range" do
    tag = Factory.create(:fundraiser_tag)
    type1 = Factory.create(:fundraiser_type)
    type2 = Factory.create(:fundraiser_type)
    type1.fundraiser_tags << tag
    type2.fundraiser_tags << tag

    type1.minimum_typical_amount_raised_in_cents = 1000
    type1.maximum_typical_amount_raised_in_cents = 2000
    type1.save
    type2.minimum_typical_amount_raised_in_cents = 1000
    type2.maximum_typical_amount_raised_in_cents = 3000
    type2.save
    ranges = FundraiserTag.determine_fundraising_goal_ranges([tag.id])
    assert_equal 1, ranges.size
    assert_equal 1, ranges[0].id
    
    type1.minimum_typical_amount_raised_in_cents = 600000
    type1.maximum_typical_amount_raised_in_cents = 700000
    type1.save
    type2.minimum_typical_amount_raised_in_cents = 800000
    type2.maximum_typical_amount_raised_in_cents = 900000
    type2.save
    ranges = FundraiserTag.determine_fundraising_goal_ranges([tag.id])
    assert_equal 1, ranges.size
    assert_equal 2, ranges[0].id
    
    type1.minimum_typical_amount_raised_in_cents = 1100000
    type1.maximum_typical_amount_raised_in_cents = 1200000
    type1.save
    type2.minimum_typical_amount_raised_in_cents = 1050000
    type2.maximum_typical_amount_raised_in_cents = 1250000
    type2.save
    ranges = FundraiserTag.determine_fundraising_goal_ranges([tag.id])
    assert_equal 1, ranges.size
    assert_equal 3, ranges[0].id
  end
  
  test "correct fundraising goal for multiple types of multiple ranges" do
    tag = Factory.create(:fundraiser_tag)
    type1 = Factory.create(:fundraiser_type)
    type2 = Factory.create(:fundraiser_type)
    type1.fundraiser_tags << tag
    type2.fundraiser_tags << tag

    type1.minimum_typical_amount_raised_in_cents = 1000
    type1.maximum_typical_amount_raised_in_cents = 2000
    type1.save
    type2.minimum_typical_amount_raised_in_cents = 1100000
    type2.maximum_typical_amount_raised_in_cents = 1200000
    type2.save
    ranges = FundraiserTag.determine_fundraising_goal_ranges([tag.id])
    assert_equal 2, ranges.size
    assert_equal 1, ranges[0].id
    assert_equal 3, ranges[1].id
    
    type1.minimum_typical_amount_raised_in_cents = 1000
    type1.maximum_typical_amount_raised_in_cents = 600000
    type1.save
    type2.minimum_typical_amount_raised_in_cents = 700000
    type2.maximum_typical_amount_raised_in_cents = 1200000
    type2.save
    ranges = FundraiserTag.determine_fundraising_goal_ranges([tag.id])
    assert_equal 3, ranges.size
    assert_equal 1, ranges[0].id
    assert_equal 2, ranges[1].id
    assert_equal 3, ranges[2].id
    
    type1.minimum_typical_amount_raised_in_cents = 1000
    type1.maximum_typical_amount_raised_in_cents = 12000000
    type1.save
    type2.minimum_typical_amount_raised_in_cents = 2000
    type2.maximum_typical_amount_raised_in_cents = 3000
    type2.save
    ranges = FundraiserTag.determine_fundraising_goal_ranges([tag.id])
    assert_equal 3, ranges.size
    assert_equal 1, ranges[0].id
    assert_equal 2, ranges[1].id
    assert_equal 3, ranges[2].id
  end


  
end
