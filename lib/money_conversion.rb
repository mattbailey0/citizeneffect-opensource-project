module MoneyConversion
  def MoneyConversion.cents_to_dollars(money_in_cents)
    some_float = money_in_cents.to_f / 100
    some_string_front, some_string_back = some_float.to_s.split(".")
    "#{some_string_front}.#{some_string_back[0..2]}".to_f
  end

  def MoneyConversion.dollars_to_cents(money_in_dollars)
    some_float = money_in_dollars.to_f * 100
    some_string_front, some_string_back = some_float.to_s.split(".")
    "#{some_string_front}".to_i
  end
end
