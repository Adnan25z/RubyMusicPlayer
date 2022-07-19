
# Display the prompt and return the read string
def read_string prompt
	puts prompt
	value = gets.chomp
end

# Display the prompt and return the read float
def read_float prompt
	value = read_string(prompt)
	value.to_f
end

# Display the prompt and return the read integer
def read_integer prompt
	value = read_string(prompt)
	value.to_i
end

# Read an integer between min and max, prompting with the string provided

def read_integer_in_range(prompt, min, max)
	value = read_integer(prompt)
	while (value < min or value > max)
		puts "Please enter a value between " + min.to_s + " and " + max.to_s + ": "
		value = read_integer(prompt);
	end
	value
end

# Display the prompt and return the read Boolean

def read_boolean prompt
	value = read_string(prompt)
	case value
	when 'y', 'yes', 'Yes', 'YES'
		true
	else
		false
	end
end

# Test the functions above
=begin
def main
	puts "String entered is: " + read_string("Enter a String: ")
	puts "Boolean is: " + read_boolean("Enter yes or no:").to_s
	puts "Float is: " + read_float("Enter a floating point number: ").to_s
	puts "Integer is: " + read_integer_in_range("Enter an integer between 3 and 6: ", 3, 6).to_s
end

main
=end



=begin
if @albums.length == 1
	if mouse_x > 50 and mouse_y > 100 and mouse_x < 250 and mouse_y < 300
	  @choice = 0
	end
  elsif @albums.length == 2
	if ((mouse_x > 50 and mouse_x < 250) and (mouse_y > 100 and mouse_y < 300))
	  @choice = 0
	elsif((mouse_x > 270 and mouse_x < 470) and (mouse_y > 100 and mouse_y < 300))
	  @choice = 1
	end  
  elsif @albums.length == 3
	if ((mouse_x > 50 and mouse_x < 250) and (topY > 100 and mouse_y < 300))
	  @choice = 0
	elsif((mouse_x > 270 and mouse_x < 470) and (topY > 100 and mouse_y < 300))
	  @choice = mouse_x
	elsif ((mouse_x > 50 and mouse_x < 250) and (topY > 350 and mouse_y < 550))
	  @choice = 2
	end  
  elsif @albums.length == 4
	if ((mouse_x > 50 and mouse_x < 250) and (mouse_y > 100 and mouse_y < 300))
	  @choice = 0
	elsif((mouse_x > 270 and mouse_x < 470) and (mouse_y > 100 and mouse_y < 300))
	  @choice = 1
	elsif ((mouse_x > 50 and mouse_x < 250) and (mouse_y > 350 and mouse_y < 550))
	  @choice = 2
	elsif((mouse_x > 270 and mouse_x < 470) and (mouse_y > 350 and mouse_y < 550))
	  @choice = 3        
	end  
  end
  =end