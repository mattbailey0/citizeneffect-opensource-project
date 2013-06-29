require File.dirname(__FILE__) + "/../test_helper"

class ProjectTest < ActiveSupport::TestCase
  
  test "projects have state_update_at set on creation" do
    assert_not_nil Factory.create(:project).state_updated_at
  end

  test "projects with external text columns can be deleted" do
    p = Factory.create(:project)
    assert p.update_attributes(:primary_objective => "testy")
    assert_match "testy", p.primary_objective
    assert_difference "Project.count", -1 do
      p.destroy
    end
  end

  test "project sets its approved_by_citizen_effect_at when it becomes user visible" do
    #moving from draft to awaiting cp
    p = Factory.create(:project_with_basic_data)
    assert_nil p.approved_by_citizen_effect_at
    
    p.project_status = ProjectStatus.awaiting_cp
    p.save
    assert_not_nil p.approved_by_citizen_effect_at
    
    #moving from draft to fundraising
    p_ = Factory.create(:project_with_basic_data)
    assert_nil p_.approved_by_citizen_effect_at
    
    p_.cp = Factory.create("cp")
    p_.save
    assert_nil p_.approved_by_citizen_effect_at
  end
end
