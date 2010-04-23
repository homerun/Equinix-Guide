class CreateNetworktermptowners < ActiveRecord::Migration
  def self.up
    create_table :networktermptowners do |t|
      t.string :name
      t.timestamps
    end
    
    ['Equinix',"365 Main", "@Tokyo", "ACTIV Financial", "Acxiom", "ASX Limited", "AT&T", "Broadwing", "BT Radianz", "Chicago Board of Trade", "City Lifeline", "CME Group", "CRG West", "Datacom",'DCI Technology Holdings','Digital Realty Trust','Direct Edge','Eurex','FiberMedia','FiberNet','Fujitsu','Global Switch','Hong Kong Land','iAdvantage','Interactive Data Corp','International Continental Exchange','International Securities Exchange','Interxion','iPrimus','KDDI','Keppel Digihub','Korea Exchange (KRX)','KVH','Level(3)','London Hosting Centre','Macquarie Telecom Intellicentre','New York Mercantile Exchange','Optus Expan','Osaka Stock Exchange','Philadelphia Stock Exchange','PowerTel','QTS','Qwest','RCN','Reach','Rudin Management Company','SAVVIS','ServePath','SIAC','Singapore Exchange, LTD','Singtel','Steadfast Networks','Sungard','Switch & Data','Technical Real Estate','TelecityGroup','Telehouse','Telekurs Financial','Telstra','Telx','Terremark','Tokyo Commodities Exchange','Tokyo Financial Exchange','Tokyo Stock Exchange','Tudor Investment Corp.','Unicom''United States Federal Government','Unknown','Verizon','Vital'].each do |o|
      owner = Networktermptowner.new
      owner.name = o
      owner.save!
    end
  end

  def self.down
    drop_table :networktermptowners
  end
end
