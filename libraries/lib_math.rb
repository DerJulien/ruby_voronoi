def range (lo=0, hi=1,dec=2)
    val = rand * (hi-lo) + lo
    return val.round(dec)
end
def lerp(start, stop, step)
  (stop * step) + (start * (1.0 - step))
end
def normalise(x, xmin, xmax, ymin=0, ymax=1)
  xrange = xmax - xmin
  yrange = ymax - ymin
  ymin + (x - xmin) * (yrange.to_f / xrange)
end
