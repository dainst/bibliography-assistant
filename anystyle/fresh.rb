require 'anystyle'

AnyStyle.parser.train 'fresh.xml', truncate: true
AnyStyle.parser.model.path = './fresh.mod'
AnyStyle.parser.model.save
