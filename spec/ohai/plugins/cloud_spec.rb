#
# Author:: Cary Penniman (<cary@rightscale.com>)
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper.rb')

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper.rb')

describe Ohai::System, "plugin cloud" do
  before(:each) do
    @ohai = Ohai::System.new
    @plugin = Ohai::DSL::Plugin.new(@ohai, File.join(PLUGIN_PATH, "cloud.rb"))
    @plugin.stub!(:require_plugin).and_return(true)
  end

  describe "no cloud" do
    it "should NOT populate the cloud data" do
      @plugin[:ec2] = nil
      @plugin[:rackspace] = nil
      @plugin[:eucalyptus] = nil
      @plugin.run
      @plugin[:cloud].should be_nil
    end
  end
  
  describe "with EC2" do
    before(:each) do
      @plugin[:ec2] = Mash.new()
    end  
    
    it "should populate cloud public ip" do
      @plugin[:ec2]['public_ipv4'] = "174.129.150.8"
      @plugin.run
      @plugin[:cloud][:public_ips][0].should == @plugin[:ec2]['public_ipv4']
    end

    it "should populate cloud private ip" do
      @plugin[:ec2]['local_ipv4'] = "10.252.42.149"
      @plugin.run
      @plugin[:cloud][:private_ips][0].should == @plugin[:ec2]['local_ipv4']
    end
    
    it "should populate cloud provider" do
      @plugin.run
      @plugin[:cloud][:provider].should == "ec2"
    end
  end
  
  describe "with rackspace" do
    before(:each) do
      @plugin[:rackspace] = Mash.new()
    end  
    
    it "should populate cloud public ip" do
      @plugin[:rackspace]['public_ip'] = "174.129.150.8"
      @plugin.run
      @plugin[:cloud][:public_ips][0].should == @plugin[:rackspace][:public_ip]
    end
        
    it "should populate cloud private ip" do
      @plugin[:rackspace]['private_ip'] = "10.252.42.149"
      @plugin.run
      @plugin[:cloud][:private_ips][0].should == @plugin[:rackspace][:private_ip]
    end
    
     it "should populate first cloud public ip" do
      @plugin[:rackspace]['public_ip'] = "174.129.150.8"
      @plugin.run
      @plugin[:cloud][:public_ips].first.should == @plugin[:rackspace][:public_ip]
    end
        
    it "should populate cloud provider" do
      @plugin.run
      @plugin[:cloud][:provider].should == "rackspace"
    end
  end
  
  describe "with eucalyptus" do
    before(:each) do
      @plugin[:eucalyptus] = Mash.new()
    end  
    
    it "should populate cloud public ip" do
      @plugin[:eucalyptus]['public_ipv4'] = "174.129.150.8"
      @plugin.run
      @plugin[:cloud][:public_ips][0].should == @plugin[:eucalyptus]['public_ipv4']
    end

    it "should populate cloud private ip" do
      @plugin[:eucalyptus]['local_ipv4'] = "10.252.42.149"
      @plugin.run
      @plugin[:cloud][:private_ips][0].should == @plugin[:eucalyptus]['local_ipv4']
    end
        
    it "should populate cloud provider" do
      @plugin.run
      @plugin[:cloud][:provider].should == "eucalyptus"
    end
  end
  
end
