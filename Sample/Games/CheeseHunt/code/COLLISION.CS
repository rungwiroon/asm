public static bool Intersect(Rectangle rectangle1, Rectangle rectangle2)
{
  if (((rectangle1.X < (rectangle2.X + rectangle2.Width)) 
    && (rectangle2.X < (rectangle1.X + rectangle1.Width))) 
    && (rectangle1.Y < (rectangle2.Y + rectangle2.Height)))
  {
    return (rectangle2.Y < (rectangle1.Y + rectangle1.Height));
  }
  return false;
}

public static Rectangle Intersection(Rectangle rectangle1, Rectangle rectangle2)
{
  int x1 = Math.Max(rectangle1.Left, rectangle2.Left);
  int y1 = Math.Max(rectangle1.Top, rectangle2.Top);
  int x2 = Math.Min(rectangle1.Right, rectangle2.Right);
  int y2 = Math.Min(rectangle1.Bottom, rectangle2.Bottom);

  if ((x2 >= x1) && (y2 >= y1))
  {
    return new Rectangle(x1, y1, x2 - x1, y2 - y1);
  }
  return Rectangle.Empty;
}

public static Rectangle Normalize(Rectangle reference, Rectangle rectangle)
{
  return new Rectangle(
    rectangle.X - reference.X,
    rectangle.Y - reference.Y,
    rectangle.Width,
    rectangle.Height);
}

public static bool TestCollision(
  Texture2D texture1, Rectangle texture1Intersection,
  Texture2D texture2, Rectangle texture2Intersection)
{
  int pixelCount = texture1Intersection.Width * texture1Intersection.Height;
  uint[] texture1Pixels = new uint[pixelCount];
  uint[] texture2Pixels = new uint[pixelCount];

  texture1.GetData(0, texture1Intersection, texture1Pixels, 0, pixelCount);
  texture2.GetData(0, texture2Intersection, texture2Pixels, 0, pixelCount);
  for (int i = 0; i < pixelCount; ++i)
  {
    if (((texture1Pixels[i] & 0xff000000) > 0)
      && ((texture2Pixels[i] & 0xff000000) > 0))
    {
      return true;
    }
  }
  return false;
}

