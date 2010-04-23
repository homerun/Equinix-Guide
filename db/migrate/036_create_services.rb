class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.integer :pointsofinterest_id
      t.string :service_acronym, :name
      t.text :description
      t.timestamps
    end
    

    s = Service.new
    s.pointsofinterest_id = Pointsofinterest.find_by_name("Hong Kong Stock Exchange").id
    s.service_acronym = 'AMS/3'
    s.name = 'Automatic Order Matching and Execution System (3rd Generation)'
    s.save! 
    
    s = Service.new
    s.pointsofinterest_id = Pointsofinterest.find_by_name("Hong Kong Stock Exchange").id
    s.service_acronym = 'OTS'
    s.name = 'Online Trading Service Channel'
    s.description = "OTS is supported directly by HKEx. Investors can place orders through the Internet developed by the HKEx. The orders will be routed to Stock Exchange Participants via Order Routing System (ORS)"
    s.save!
    
    s = Service.new
    s.pointsofinterest_id = Pointsofinterest.find_by_name("Australian Securities Exchange").id
    s.service_acronym = 'ITS'
    s.name = 'Integrated Trading Systems'
    s.description = "ASX's Open Interface"
    s.save!
    
    s = Service.new
    s.pointsofinterest_id = Pointsofinterest.find_by_name("ASX Austraclear").id
    s.service_acronym = 'CSD'
    s.name = 'Central Securities Depository services'
    s.description = 'Austraclear holds more than 95% of the total issuance of Fixed Income Securities in the Australian Financial Markets offering participants the unique solution of holding these securities as a Nominee.  It also performs the function of Bailee (Custodians).'
    s.save!
  end

  def self.down
    drop_table :services
  end
end


#insert  into `services`(`id`,`pointsofinterest_id`,`service_acronym`,`name`,`description`) 
#(6,4,'ETC','Electronic Trade Confirmation and Settlement','ASX Austraclear provides completely electronic Confirmation and Settlement services to  reduce operational risk, increase Straight Through Processing (STP), and reduce resource and technology costs. In addition, our service has the added benefit of being '),
#(7,4,'ECT','Electronic Cash Transfers','The ASX Austraclear Electronic Trade Settlement service for the transfer of cash provides the capability to settle cash transfers via the RBA Real Time Gross Settlement (RTGS) system'),(9,62,'PCX','PacificExchange',NULL),(10,63,'OMDF','OTC Montage Data Feed','Provides top-of-file market participant quotations for the FINRA Alternative Display Facility (ADF) for NASDAQ-listed issues.'),(11,64,'CQS','Consolidated Quotation System','Consolidated Quotation System'),(12,64,'CTS','Consolidated Tape System','Is the electronic service that provides last sale and trade data for issues admitted to dealings on the American Stock Exchange, New York Stock Exchange, and U.S. regional stock exchanges.'),(13,63,'NQDS Level 2','NASDAQ Quotation Dissemination Service Level 2','Shows all public quotes of market makers together with information of market makers wishing to sell or buy stock and recently executed orders.'),
#(14,63,'TotalView-ITCH 3.0',NULL,'?'),(15,63,'TDDS','Trade Data Dissemination Service',NULL),(16,63,'UQDF','UTP Quotation Data Feed','Provides best bid and offer (BBO) quotes\r\nfrom the UTP participants as well as the consolidated national best bid and offer\r\n(National BBO) quotes for securities listed on the NASDAQ Stock Market'),(17,63,'UTDF','UTP Trade Data Feed','Provides trade data from the UTP participants for\r\nsecurities listed on the NASDAQ Stock Market'),(18,63,'BBDS','Bulletin Board Dissemination Service',NULL),(19,66,'Millennium','Millennium',NULL),
#(20,66,'Euro-Millennium','Euro-Millennium',NULL),(21,59,'LRP','Liquidity Replenishment Points','Information related to the NYSE\'s Hybrid Market initiative. The NYSE LRP data feed provides real-time messages regarding the pre-determined price points at which electronic trading briefly converts to auction market trading.'),(22,75,'PITCH','PITCH',''),(23,75,'FAST PITCH','FAST PITCH','A compressed feed based on the FAST protocol'),(24,59,'SFTI','Secure Financial Transaction Infrastructure','offers firms access to SIAC for the New York Stock Exchange, the American Stock Exchange, Clearing Corporation and Market Data services. SFTI B2B, available through SIAC’s subsidiary, Sector, Inc., utilizes the SFTI infrastructure to carry order traffic a'),
#(25,63,'CTCI','Computer-to-computer interface','A method by which NASDAQ subscribers can enter transactions, such as NASDAQ Market Center orders and trade reports, from their computer systems to NASDAQ\'s computer systems without using a NASDAQ Workstation. The CTCI interface is based on the Common Mess'),
#(26,13,'SGXAccess','SGXAccess','Allows SGX member firms access to the Exchange\'s matching engine and trade in its securities market products from anywhere in the world.'),(27,13,'SGXLink','SGXLink','A multi-lateral cross border trading gateway was also established to facilitate direct access to foreign markets.'),(28,7,'Quotes','Quotes','Quote vendors receive the market information directly from TFX.'),(29,7,'Sub-Quotes','Sub-Quotes','Sub-Quote vendors receive the market information from a Quote Vendor.'),(30,7,'FX',NULL,NULL),(31,17,'EDCSST',NULL,'Open/High/Low/Close Prices'),
#(32,17,'TCBFL1',NULL,'Tick Data - Level 1'),(33,17,'TCBFL2',NULL,'Tick Data - Level 2'),(34,17,'INTXED',NULL,'Index Data - Open/High/Low/Close'),(35,17,'INTXCP',NULL,'Index Data - Closing Price'),(36,17,'INTXMC',NULL,'Index Data - Monthly Closing Price'),(37,17,'INTXTC',NULL,'Index Data - Tick Data'),(38,17,'TMIDTL',NULL,'TMI Historical Data -  Constituent information'),
#(39,17,'TMIINX',NULL,'TMI Historical Data - Price return index information'),(40,17,'TMIDIX',NULL,'TMI Historical Data - Total return index information'),(41,17,'TMINOT',NULL,'TMI Historical Data - Advance notice'),(42,17,'DFSOID',NULL,'Historical Data for Open Interest of Margin Transactions'),(43,22,'FIX?',NULL,'FIX?'),(44,22,'Market Data',NULL,'Market Data?'),(45,157,'','Labor Statistics','Indices and statistics produced by the BLS include:\r\n\r\n    * U.S. Consumer Price Index\r\n    * National Compensation Survey\r\n          o Employment Cost Index\r\n          o Employer Costs for Employee Compensation\r\n    * Producer Price Index\r\n    * Consumer'),(46,155,'','Commerce Statistics',''),
#(47,156,'','Treasury Statistics',''),
#(48,133,'SIGMA','SIGMA','In Europe, Goldman Sachs offers the SIGMA suite of products: liquidity-seeking algorithms, smart order routing and aggregation tools, sophisticated crossing logic and a comprehensive set of analytics. The SIGMA suite enables you to access multiple liquidi'),
#(49,133,'SIGMA X','SIGMA X','The largest pool of non-displayed liquidity in the U.S.1, SIGMA X is comprised of a customer-to-customer crossing network and a host of external liquidity providers. SIGMA X allows customers to take liquidity from nondisplayed sources and benefit from the'),(50,158,'MS POOL','MS POOL','Morgan Stanley\'s premier liquidity destination, combining multiple sources of order flow into one aggregated dark pool of liquidity. MS POOL provides enhanced crossing opportunities and price improvement to their clients.'),
#(51,159,'UBS PIN','UBS PIN','UBS Price Improvement Network (UBS PIN) is their internal matching pool. UBS trades 400-plus million shares a day in the U.S. Nearly half is retail. This means greater diversity of stocks -- from small-cap to large-cap.'),(52,166,'eBTS','electronic Block Trading System','eBTS will enable customers to instantaneously source block size liquidity in US Futures and Options on a neutral and anonymous electronic platform.  LiquidityPort will support Request for Quote (RFQ) and Bulletin Board Trading. All transactions will be ce'),
#(53,167,'VBBO','Volume weighted Best Bid and Offer','The VBBO, a single source of Pan-European Equity Reference price data. A cost effective alternative to multiple potentially expensive sources.'),(54,167,'','PartnerEx ','PartnerEx allows a Market maker to hold multiple two-way agreements with the same Order Flow Provider and with different Order Flow Providers - and vice versa for Order Flow Providers. Market participants can thus tailor and maximize client service levels'),(55,167,'HybridBook','Hybrid Book','To help you avoid the high costs incurred by cross-border clearing and settlement, Equiduct Trading  HybridBook uses the existing clearing and settlement arrangements of the domestic market.'),
#(56,169,'SFTI B2B','SFTI B2B','SFTI B2B can provide connectivity to the following:\r\n\r\nActiv Financial\r\nADP Wilco\r\nAmerican Stock Exchange\r\nThe Bank of New York (BONY)\r\nBATS\r\nBoston Options Exchange (BOX)\r\nCBOE\r\nChicago Stock Exchange (CHX)\r\nCurrenex\r\nEuronext-Liffe\r\nISE\r\nMontreal Excha'),(57,169,'','NYSE - Automated Bond System (CTC) via ARCA ONLY',''),
#(58,169,'','NYSE - NYSE - Automated Bond System (CTC) via ARCA ONLY',''),(59,169,'','NYSE - Automated Bond System - High Speed Quote Link via ARCA ONLY',''),(60,169,'','NYSE - CAPTest System',''),(61,169,'','NYSE - Common Message Switch (CMS) - FCS Message Protocol',''),(62,169,'OpenBook','NYSE - NYSE OpenBook Production',''),(63,130,'Direct Edge Services','Direct Edge Services Placeholder',''),(64,122,'CME Services','CME Services Placeholder',''),(65,237,'','LIFFE CONNECT','Market Access to LIFFE CONNECT® can be accessed electronically from the world’s major financial centres.\r\n\r\nUsers have considerable flexibility and choice of networks including:\r\n\r\n    * Direct access via the NYSE Euronext Network, (regulatory restriction'),
#(66,68,'Level 1/Real-time','Eurex Level 1/Real-time',''),(67,68,'Level 1/Delayed','Eurex Level 1/Delayed',''),(68,68,'Level 2/Real-time','Eurex Level 2/Real-time',''),(69,68,'Level 2/Delayed','Eurex Level 2/Delayed','');
