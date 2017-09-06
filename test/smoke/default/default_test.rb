# # encoding: utf-8

# Inspec test for recipe jupyter::default

describe command('jupyter --version') do
  its(:stdout) { should match(/\A4.3.0\Z/) }
end

describe port(8888) do
  it 'should eventually be listening to a port' do
    sleep 1
    should be_listening
  end
end

describe command('curl -L localhost:8888') do
  its(:stdout) { should match(/jupyter/) }
end
