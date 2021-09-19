class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      case item.name
      when 'Aged Brie'
        quality = item.sell_in.positive? ? 1 : 2
        item.increase_quality(quality)
        item.decrease_sell_in
      when 'Backstage passes to a TAFKAL80ETC concert'
        number_decrease = if item.sell_in > 10
                            1
                          elsif item.sell_in > 5
                            2
                          elsif item.sell_in > 0
                            3
                          end
        quality = item.sell_in.positive? ? number_decrease : -50
        item.increase_quality(quality)
        item.decrease_sell_in
      when 'Sulfuras, Hand of Ragnaros'
        next
      else
        item.decrease_sell_in
        item.decrease_quality
      end
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

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

  def decrease_quality(number = 1)
    number_decrease = @sell_in >= 0 ? number : number * 2
    @quality =  @quality > number_decrease ? @quality - number_decrease : MIN_QUALITY
  end

  def increase_quality(number = 1)
    @quality = @quality <= (MAX_QUALITY - number) ?  @quality + number : MAX_QUALITY
  end

  def decrease_sell_in(number = 1)
    @sell_in -= number
  end
end
