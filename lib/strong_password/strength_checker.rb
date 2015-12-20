module StrongPassword
  class StrengthChecker
    BASE_ENTROPY = 18

    attr_reader :base_password

    def initialize(password)
      @base_password = password.dup
    end


    def calculate_entropy
      [
         EntropyCalculator.calculate( base_password ),
         EntropyCalculator.calculate( base_password.downcase, :nist_bonus => false ),
         QwertyAdjuster.new( base_password ).adjusted_entropy,
         DictionaryAdjuster.new( base_password ).adjusted_entropy
      ].min
    end
  end
end