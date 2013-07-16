require 'seeing_is_believing/binary/remove_previous_annotations'

describe SeeingIsBelieving::Binary::RemovePreviousAnnotations do
  def call(code)
    indentation = code[/\A */]
    code        = code.gsub /^#{indentation}/, ''
    described_class.call(code).chomp
  end

  # show some examples of what it should not remove

  example { call("1#=>1").should == "1" }
  example { call("1 #=>1").should == "1" }
  example { call("1  #=>1").should == "1" }
  example { call("1  #=> 1").should == "1" }
  example { call("1   #=> 1").should == "1" }
  example { call("1  #=>  1").should == "1" }

  example { call("1#~>1").should == "1" }
  example { call("1 #~>1").should == "1" }
  example { call("1  #~>1").should == "1" }
  example { call("1  #~> 1").should == "1" }
  example { call("1   #~> 1").should == "1" }
  example { call("1  #~>  1").should == "1" }

  example { call("# >> 1").should == "" }
  example { call("# !> 1").should == "" }

  example { call(<<-CODE).should == "1" }
  1
  # >> 2
  CODE

  example { call(<<-CODE).should == "1" }
  1

  # >> 2
  CODE

  example { call(<<-CODE).should == "1\n" }
  1


  # >> 2
  CODE

  example { call(<<-CODE).should == "1\n" }
  1


    # >> 2
  # >> 2
   # >> 2
  CODE


  example { call(<<-CODE).should == "1\n" }
  1


  # >> 2
  # >> 3
  CODE

  example { call(<<-CODE).should == "1" }
  1
  # !> 2
  CODE

  example { call(<<-CODE).should == "1" }
  1

  # !> 2
  CODE

  example { call(<<-CODE).should == "1" }
  1

  # !> 2
  # !> 3
  CODE

  example { call(<<-CODE).should == "1" }
  1

  # >> 1
  # >> 2

  # !> 3
  # !> 4
  CODE

  example { call(<<-CODE).should == "1" }
  1

  # >> 1
  # >> 2
  # !> 3
  # !> 4
  CODE

  example { call(<<-CODE).should == "1\n3" }
  1
  # >> 1
  # >> 2
  3
  # !> 4
  # !> 5
  CODE
end