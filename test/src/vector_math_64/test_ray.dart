library test_ray_64;

import 'dart:math' as Math;
import 'package:unittest/unittest.dart';
import 'package:vector_math/vector_math_64.dart';
import 'test_helpers.dart';


void testAt() {
  final Ray parent = new Ray.originDirection(_v(1.0,1.0,1.0), _v(-1.0,1.0,1.0));

  final Vector3 atOrigin = parent.at(0.0);
  final Vector3 atPositive = parent.at(1.0);
  final Vector3 atNegative = parent.at(-2.0);

  expect(atOrigin.x, equals(1.0));
  expect(atOrigin.y, equals(1.0));
  expect(atOrigin.z, equals(1.0));
  expect(atPositive.x, equals(0.0));
  expect(atPositive.y, equals(2.0));
  expect(atPositive.z, equals(2.0));
  expect(atNegative.x, equals(3.0));
  expect(atNegative.y, equals(-1.0));
  expect(atNegative.z, equals(-1.0));

  atOrigin.setZero();
  atPositive.setZero();
  atNegative.setZero();

  parent.copyAt(atOrigin, 0.0);
  parent.copyAt(atPositive, 1.0);
  parent.copyAt(atNegative, -2.0);

  expect(atOrigin.x, equals(1.0));
  expect(atOrigin.y, equals(1.0));
  expect(atOrigin.z, equals(1.0));
  expect(atPositive.x, equals(0.0));
  expect(atPositive.y, equals(2.0));
  expect(atPositive.z, equals(2.0));
  expect(atNegative.x, equals(3.0));
  expect(atNegative.y, equals(-1.0));
  expect(atNegative.z, equals(-1.0));
}

void testIntersectionSphere() {
  final Ray parent = new Ray.originDirection(_v(1.0,1.0,1.0), _v(0.0,1.0,0.0));
  final Sphere inside = new Sphere.centerRadius(_v(2.0,1.0,1.0), 2.0);
  final Sphere hitting = new Sphere.centerRadius(_v(2.5,4.5,1.0), 2.0);
  final Sphere cutting = new Sphere.centerRadius(_v(0.0,5.0,1.0), 1.0);
  final Sphere outside = new Sphere.centerRadius(_v(-2.5,1.0,1.0), 1.0);
  final Sphere behind = new Sphere.centerRadius(_v(1.0,-1.0,1.0), 1.0);

  expect(parent.intersectsWithSphere(inside), equals(Math.sqrt(3.0)));
  expect(parent.intersectsWithSphere(hitting), equals(3.5 - Math.sqrt(1.75)));
  expect(parent.intersectsWithSphere(cutting), equals(4.0));
  expect(parent.intersectsWithSphere(outside), equals(null));
  expect(parent.intersectsWithSphere(behind), equals(null));
}

void testIntersectionTriangle() {
  final Ray parent = new Ray.originDirection(_v(1.0,1.0,1.0), _v(0.0,1.0,0.0));
  final Triangle hitting = new Triangle.points(_v(2.0,2.0,0.0), _v(0.0,4.0,-1.0), _v(0.0,4.0,3.0));
  final Triangle cutting = new Triangle.points(_v(0.0,1.5,1.0), _v(2.0,1.5,1.0), _v(1.0,1.5,3.0));
  final Triangle outside = new Triangle.points(_v(2.0,2.0,0.0), _v(2.0,6.0,0.0), _v(2.0,2.0,3.0));
  final Triangle behind = new Triangle.points(_v(0.0,0.0,0.0), _v(0.0,3.0,0.0), _v(0.0,3.0,4.0));

  expect(parent.intersectsWithTriangle(hitting), absoluteEquals(2.0));
  expect(parent.intersectsWithTriangle(cutting), absoluteEquals(0.5));
  expect(parent.intersectsWithTriangle(outside), equals(null));
  expect(parent.intersectsWithTriangle(behind), equals(null));

  // Test cases from real-world failures:
  // Just barely intersects, but gets rounded out
  final Ray p2 = new Ray.originDirection(
      _v(0.0,-0.16833500564098358,0.7677000164985657),
      _v(-0.0,-0.8124330043792725,-0.5829949975013733));
  final Triangle t2 = new Triangle.points(
      _v(0.03430179879069328,-0.7268069982528687,0.3532710075378418),
      _v(0.0,-0.7817990183830261,0.3641969859600067),
      _v(0.0,-0.7293699979782104,0.3516849875450134));
  expect(p2.intersectsWithTriangle(t2), absoluteEquals(0.7078371874391822));
  // Ray is not quite perpendicular to triangle, but gets rounded out
  final Ray p3 = new Ray.originDirection(
      _v(0.023712199181318283,-0.15045200288295746,0.7751160264015198),
      _v(0.6024960279464722,-0.739005982875824,-0.3013699948787689));
  final Triangle t3 = new Triangle.points(
      _v(0.16174300014972687,-0.3446039855480194,0.7121580243110657),
      _v(0.1857299953699112,-0.3468630015850067,0.6926270127296448),
      _v(0.18045000731945038,-0.3193660080432892,0.6921690106391907));
  expect(p3.intersectsWithTriangle(t3), absoluteEquals(0.2538471189773835));
}

void testIntersectionAabb3() {
  final Ray parent = new Ray.originDirection(_v(1.0, 1.0, 1.0), _v(0.0, 1.0, 0.0));
  final Aabb3 hitting = new Aabb3.minMax(_v(0.5, 3.5, -10.0), _v(2.5, 5.5, 10.0));
  final Aabb3 cutting = new Aabb3.minMax(_v(0.0, 2.0, 1.0), _v(2.0, 3.0, 2.0));
  final Aabb3 outside = new Aabb3.minMax(_v(2.0, 0.0, 0.0), _v(6.0, 6.0, 6.0));
  final Aabb3 behind = new Aabb3.minMax(_v(0.0, -2.0, 0.0), _v(2.0, 0.0, 2.0));
  final Aabb3 inside = new Aabb3.minMax(_v(0.0, 0.0, 0.0), _v(2.0, 2.0, 2.0));

  expect(parent.intersectsWithAabb3(hitting), equals(2.5));
  expect(parent.intersectsWithAabb3(cutting), equals(1.0));
  expect(parent.intersectsWithAabb3(outside), equals(null));
  expect(parent.intersectsWithAabb3(behind), equals(null));
  expect(parent.intersectsWithAabb3(inside), equals(-1.0));
}

Vector3 _v(double x, double y, double z) {
  return new Vector3(x,y,z);
}

void main() {
  group('Ray', () {
    test('At', testAt);
    test('Intersection Sphere', testIntersectionSphere);
    test('Intersection Triangle', testIntersectionTriangle);
    test('Intersection Aabb3', testIntersectionAabb3);
  });
}