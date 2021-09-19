class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      item.on_update_quality =
        case item.name
        when 'Aged Brie'
          AgedBrieCommand.new(item)
        when 'Backstage passes to a TAFKAL80ETC concert'
          BackstageCommand.new(item)
        when 'Sulfuras, Hand of Ragnaros'
          SulfurasCommand.new(item)
        when 'Conjured Mana Cake'
          ConjuredCommand.new(item)
        else
          CommandUpdateItem.new(item)
        end
      item.update_quality
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality, :on_update

  MAX_QUALITY = 50
  MIN_QUALITY = 0

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_h
    { name: @name, sell_in: @sell_in, quality: @quality }
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end

  def on_update_quality=(command)
    @on_update = command
  end

  def update_quality
    @on_update.execute if @on_update.is_a? CommandUpdateItem
  end
end

class CommandUpdateItem
  def initialize(item)
    @item = item
  end

  def execute
    decrease_quality
    decrease_sell_in
  end

  def decrease_quality(number = 1)
    number = @item.sell_in.positive? ? number : number * 2
    @item.quality =  @item.quality > number ? @item.quality - number : Item::MIN_QUALITY
  end

  def increase_quality(number = 1)
    @item.quality = @item.quality <= (Item::MAX_QUALITY - number) ?  @item.quality + number : Item::MAX_QUALITY
  end

  def decrease_sell_in(number = 1)
    @item.sell_in -= number
  end
end

class AgedBrieCommand < CommandUpdateItem
  def execute
    quality_number = @item.sell_in.positive? ? 1 : 2

    increase_quality(quality_number)
    decrease_sell_in
  end
end

class BackstageCommand < CommandUpdateItem
  def execute
    increase_quality(quality_number)
    decrease_sell_in
  end

  def quality_number
    if @item.sell_in > 10
      return 1
    elsif @item.sell_in > 5
      return 2
    elsif @item.sell_in > 0
      return 3
    else
      return -Item::MAX_QUALITY
    end
  end
end

class SulfurasCommand < CommandUpdateItem
  def execute
    @item.quality
  end
end

class ConjuredCommand < CommandUpdateItem
  def execute
    decrease_quality(2)
    decrease_sell_in
  end
end