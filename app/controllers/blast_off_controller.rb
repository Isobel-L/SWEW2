class BlastOffController < ApplicationController
  def show
    # Generate 5 random numbers (mix of small and large)
    @numbers = generate_numbers

    # Generate a target number
    @target = generate_target(@numbers)

    # Store in session for validation
    session[:numbers] = @numbers
    session[:target] = @target
  end

  def check
    user_expression = params[:expression]
    numbers = session[:numbers]
    target = session[:target]

    # Validate the expression
    result = validate_and_calculate(user_expression, numbers)

    if result[:valid] && result[:value] == target
      flash[:success] = "Correct! #{user_expression} = #{target}"
      redirect_to blast_off_path
    elsif result[:valid]
      flash[:error] = "Your answer equals #{result[:value]}, but the target is #{target}. Try again!"
      redirect_to blast_off_path
    else
      flash[:error] = result[:error]
      redirect_to blast_off_path
    end
  end

  private

  def generate_numbers
    small = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].sample(4)
    large = [15, 20, 25, 50].sample(2)
    (small + large).shuffle
  end

  def generate_target(numbers)
    # form = rand(0..4)
    form = 0
    nums = numbers.sample(4)
    case form
    when 0
      ((nums[0] + nums[1])[0..] * nums[2])[0..] + nums[3]
    end
  end

  def validate_and_calculate(expression, available_numbers)
    # Remove spaces
    expr = expression.gsub(/\s+/, '')

    # Extract numbers from expression
    used_numbers = expr.scan(/\d+/).map(&:to_i)

    # Check if only available numbers are used
    temp_available = available_numbers.dup
    used_numbers.each do |num|
      if temp_available.include?(num)
        temp_available.delete_at(temp_available.index(num))
      else
        return { valid: false, error: "You can only use each number once!" }
      end
    end

    # Check for valid operators only
    unless expr.match?(/^[\d\+\-\*\/\(\)\s]+$/)
      return { valid: false, error: "Only use +, -, *, / and parentheses!" }
    end

    # Calculate result safely
    begin
      result = eval(expr)
      { valid: true, value: result }
    rescue => e
      { valid: false, error: "Invalid expression: #{e.message}" }
    end
  end
end

