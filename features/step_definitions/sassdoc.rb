Given /^I have a sass file containing$/ do |contents|
  @sass_file = Tempfile.new('sassfile')
  @sass_file.puts contents 
  @sass_file.flush
end

When /^I parse the sass file$/ do
  parser = SassDoc::Parser.new(@sass_file.path)
  @message = parser.parse
end

Then /^the parser should say$/ do |message|
  @message.should == message
end
