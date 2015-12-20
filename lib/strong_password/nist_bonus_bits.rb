module StrongPassword
  module NistBonusBits
    @@bonus_bits_for_password = {}

    # NIST password strength rules allow up to 6 bonus bits for mixed case and non-alphabetic
    def self.bonus_bits(password)
      @@bonus_bits_for_password[password] ||= begin
        calculate_bonus_bits_for(password)
     end
    end

    # This smells bad as it's only used for testing...
    def self.reset_bonus_cache!
      @@bonus_bits_for_password = {}
    end

    def self.calculate_bonus_bits_for( password )
      # Throw away first and last characters
      pwtest = password.clone.slice( 1..-2 )

      upper   = !!(pwtest =~ /[[:upper:]]/)
      lower   = !!(pwtest =~ /[[:lower:]]/)
      numeric = !!(pwtest =~ /[[:digit:]]/)
      other   = !!(pwtest =~ /[^a-zA-Z0-9 ]/)
      space   = !!(pwtest =~ / /)

      # I had this condensed to nested ternaries but that shit was ugly
      bonus_bits = if upper && lower && other && numeric
           6
        elsif upper && lower && other && !numeric
           5
        elsif numeric && other && !upper && !lower
          -2
        elsif numeric && !other && !upper && !lower
          -6
       else
          -12
      end

      if !space
        bonus_bits = bonus_bits - 2
      elsif password.split(/\s+/).length > 3
        bonus_bits = bonus_bits + 1
      end

      bonus_bits
    end
  end
end