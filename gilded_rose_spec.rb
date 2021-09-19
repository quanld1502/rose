require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe '#update_quality' do
    context 'when the item is "normal"' do
      it 'reduces the quality by one' do
        sell_in = 10
        quality = 5

        item = Item.new('foo', sell_in, quality)
        GildedRose.new([item]).update_quality

        expect(item.quality).to eq(quality - 1)
        expect(item.sell_in).to eq(sell_in - 1)
      end

      it 'the sell by date has passed, quality degrades twice as fast' do
        sell_in = 0
        quality = 4

        item = Item.new('foo', sell_in, quality)
        GildedRose.new([item]).update_quality

        expect(item.quality).to eq(quality - 2)
        expect(item.sell_in).to eq(sell_in - 1)
      end

      it 'the quality of an item is never negative' do
        sell_in = 1
        quality = 0

        item = Item.new('bar', sell_in, quality)
        GildedRose.new([item]).update_quality

        expect(item.quality).to eq(0)
        expect(item.sell_in).to eq(0)
      end
    end

    context 'when the item has name "Aged Brie"' do
      it 'when sell_in is positive' do
        sell_in = 10
        quality = 10

        item = Item.new('Aged Brie', sell_in, quality)
        GildedRose.new([item]).update_quality
        expect(item.quality).to eq(quality + 1)
        expect(item.sell_in).to eq(sell_in - 1)
      end

      it 'when item has maximum quality' do
        sell_in = 10
        quality = 50

        item = Item.new('Aged Brie', sell_in, quality)

        GildedRose.new([item]).update_quality
        expect(item.quality).to eq(quality)
        expect(item.sell_in).to eq(sell_in - 1)
      end

      it 'when item has sell_in one day ' do
        sell_in = 1
        quality = 10

        item = Item.new('Aged Brie', sell_in, quality)

        GildedRose.new([item]).update_quality
        expect(item.quality).to eq(quality + 1)
        expect(item.sell_in).to eq(0)
      end

      it 'when item has sell_in one day ' do
        sell_in = 0
        quality = 10

        item = Item.new('Aged Brie', sell_in, quality)

        GildedRose.new([item]).update_quality
        expect(item.quality).to eq(quality + 2)
        expect(item.sell_in).to eq(-1)
      end
    end

    context 'when the item has name Sulfuras' do
      it 'the item Sulfuras never has to be sold or decreases in quality' do
        sell_in = 10
        quality = 80

        item = Item.new('Sulfuras, Hand of Ragnaros', sell_in, quality)
        GildedRose.new([item]).update_quality

        expect(item.quality).to eq(quality)
        expect(item.sell_in).to eq(sell_in)
      end
    end

    context 'when the item has name Backstage passes' do
      it 'when sell_in is zero' do
        sell_in = 0
        quality = 50

        item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in, quality)
        GildedRose.new([item]).update_quality

        expect(item.quality).to eq(0)
        expect(item.sell_in).to eq(sell_in - 1)
      end

      it 'when sell_in are 10 days or less' do
        sell_in = 10
        quality = 40

        item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in, quality)
        GildedRose.new([item]).update_quality

        expect(item.quality).to eq(quality + 2)
        expect(item.sell_in).to eq(sell_in - 1)
      end

      it 'when sell_in are 3 days or less' do
        sell_in = 3
        quality = 40

        item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in, quality)
        GildedRose.new([item]).update_quality

        expect(item.quality).to eq(quality + 3)
        expect(item.sell_in).to eq(sell_in - 1)
      end
    end
  end
end