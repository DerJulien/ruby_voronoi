def measure(&block)
  start = Time.now
    block.call
  Time.now - start
end

class Grid
  def initialize(width=1,height=1,value=-1)
    @width = width; @height = height;
    @data = Array.new(width) { Array.new(height,value) }
    @backup = @data;
    @points = Array.new();
  end

  def get_width()
    return @width;
  end
  def get_height()
    return @height;
  end
  #-----------------------------------------------------
  def fill(type=-1)
    @data.each { |subarr| subarr.fill(type) }
  end

  #-----------------------------------------------------
  def get(x,y)
    if (x.between?(0,@width-1) && y.between?(0,@height-1)) then
      return @data[x][y];
    else
      return nil
    end
  end
  alias :g :get

  def set(x,y,val)
    if (x.between?(0,@width-1) && y.between?(0,@height-1)) then
      @data[x][y] = val;
    else
      return nil
    end
  end
  alias :s :set

  def add(x,y,val)
    if (x.between?(0,@width-1) && y.between?(0,@height-1)) then
      @data[x][y] = val+ g(x,y);
    else
      return nil
    end
  end
  alias :a :add

  def replace(val,newval,mode)
    @data.each do |subarr|
      case mode
        when 0
          subarr.map! { |x| x == val ? newval : x }
        when 1
          subarr.map! { |x| x > val ? newval : x }
        when -1
          subarr.map! { |x| x < val ? newval : x }
      end
    end
  end
  #-----------------------------------------------------
  def set_line(x0,y0,x1,y1,value)
    dx = (x1-x0).abs     ; sx = x0<x1 ? 1 : -1;
    dy = (y1-y0).abs * -1; sy = y0<y1 ? 1 : -1;
    err = dx + dy; e2 = dx + dy;

    while (x0!=x1 && y0!=y1) do

      s(x0,y0,value);
      e2 = 2*err;
      if (e2 > dy) then
        err += dy; x0 += sx;
      elsif (e2 < dx) then
         err += dx; y0 += sy;
      end
    end
  end

  def get_line(x0,y0,x1,y1)
      dx = (x1-x0).abs     ; sx = x0<x1 ? 1 : -1;
      dy = (y1-y0).abs * -1; sy = y0<y1 ? 1 : -1;
      err = dx + dy; e2 = dx + dy;

      varr = Array.new();
      while (x0!=x1 && y0!=y1) do

        varr.push( g(x0,y0) );
        e2 = 2*err;
        if (e2 > dy) then
          err += dy; x0 += sx;
        elsif (e2 < dx) then
           err += dx; y0 += sy;
        end
      end
      varr.compact!
      return varr;
  end

  def get_circle(xs,ys,radius)
    varr = Array.new();
    x = radius-1;
    y = 0;
    dx = 1;
    dy = 1;
    err = dx - (radius << 1);
    while (x >= y) do
        varr.push( g(xs + x, ys + y) );
        varr.push( g(xs + y, ys + x) );
        varr.push( g(xs - y, ys + x) );
        varr.push( g(xs - x, ys + y) );
        varr.push( g(xs - x, ys - y) );
        varr.push( g(xs - y, ys - x) );
        varr.push( g(xs + y, ys - x) );
        varr.push( g(xs + x, ys - y) );
        if (err <= 0) then
            y+=1;
            err += dy;
            dy += 2;
        else
            x-=1;
            dx += 2;
            err += dx - (radius << 1);
        end
    end
    varr.compact!
    return varr;
  end

  def set_circle(xs,ys,radius,value)
    x = radius-1;
    y = 0;
    dx = 1;
    dy = 1;
    err = dx - (radius << 1);
    while (x >= y) do
        s(xs + x, ys + y,value);
        s(xs + y, ys + x,value);
        s(xs - y, ys + x,value);
        s(xs - x, ys + y,value);
        s(xs - x, ys - y,value);
        s(xs - y, ys - x,value);
        s(xs + y, ys - x,value);
        s(xs + x, ys - y,value);
        if (err <= 0) then
            y+=1;
            err += dy;
            dy += 2;
        else
            x-=1;
            dx += 2;
            err += dx - (radius << 1);
        end
    end
  end

  def add_circle(xs,ys,radius,value)
    temp = Grid.new((radius* 2)-1,(radius* 2)-1,0)
    xx = xs; yy = ys;
    xs = radius-1; ys = radius-1;
    x = radius-1;
    y = 0;
    dx = 1;
    dy = 1;
    err = dx - (radius << 1);
    while (x >= y) do
        temp.s(xs + x, ys + y,value);
        temp.s(xs + y, ys + x,value);
        temp.s(xs - y, ys + x,value);
        temp.s(xs - x, ys + y,value);
        temp.s(xs - x, ys - y,value);
        temp.s(xs - y, ys - x,value);
        temp.s(xs + y, ys - x,value);
        temp.s(xs + x, ys - y,value);
        if (err <= 0) then
            y+=1;
            err += dy;
            dy += 2;
        else
            x-=1;
            dx += 2;
            err += dx - (radius << 1);
        end
    end
      add_grid(temp,xx-radius,yy-radius)
    temp = nil;
  end
  #-----------------------------------------------------
  def backup()
    @backup = @data;
  end
  def import(loadedgrid=@backup)
    backup();
    @data = loadedgrid;
  end
  def export()
    return @data;
  end
  alias :get_all :export
  def log()
    @data.each do |subarr| p subarr end
  end

  def add_grid(temp,xs,ys)

    @data.each_with_index do |subarr, x|
      subarr.each_with_index do |cell, y|
        if (x.between?(xs,xs+temp.get_width()-1) && y.between?(ys,ys+temp.get_height()-1))
          a(x,y,temp.g(x-xs,y-ys));
        end
      end
    end

  end
  #-----------------------------------------------------
  def normalise_range(lo=0,hi=1)
    curlo = (@data.flatten).min;
    curhi = (@data.flatten).max;
    @data.each_with_index do |subarr, x|
      subarr.each_with_index do |cell, y|
        value = normalise(g(x,y),curlo,curhi,lo,hi);
                s(x,y,value);
      end
    end
  end

  def randomize_points(amount)
    amount.times do
        x = rand(@width); y = rand(@height);
        @points.push([x,y])
      end
  end
  def apply_voronoi(range)
    r = range;
        @points.each do |c|
          x = c[0]; y = c[1];
          add_circle(x,y,r,1);
        end
      replace(2,0,-1)
      replace(2,2,1)
  end
  #-----------------------------------------------------
  def draw(file)
    @data.each_with_index do |subarr, x|
      subarr.each_with_index do |cell, y|
        case cell
          when 1..2
            file[x,y] =ChunkyPNG::Color.rgba(255, 0, 0, 255)
          when 0..1
            file[x,y] =ChunkyPNG::Color.rgba(0, 255, 0, 255)
        end
      end
    end
    @points.each do |c|
      x = c[0]; y = c[1];
      file[x,y] =ChunkyPNG::Color.rgba(0, 0, 255, 255)
    end
  end
end
