// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library vector_math.test.matrix4_test;

import 'dart:math' as Math;
import 'dart:typed_data';

import 'package:test/test.dart';

import 'package:vector_math/vector_math.dart';

import 'test_utils.dart';

void testMatrix4InstacingFromFloat32List() {
  final Float32List float32List = new Float32List.fromList([
    1.0,
    2.0,
    3.0,
    4.0,
    5.0,
    6.0,
    7.0,
    8.0,
    9.0,
    10.0,
    11.0,
    12.0,
    13.0,
    14.0,
    15.0,
    16.0
  ]);
  final Matrix4 input = new Matrix4.fromFloat32List(float32List);

  expect(input.storage[0], equals(1.0));
  expect(input.storage[1], equals(2.0));
  expect(input.storage[2], equals(3.0));
  expect(input.storage[3], equals(4.0));

  expect(input.storage[4], equals(5.0));
  expect(input.storage[5], equals(6.0));
  expect(input.storage[6], equals(7.0));
  expect(input.storage[7], equals(8.0));

  expect(input.storage[8], equals(9.0));
  expect(input.storage[9], equals(10.0));
  expect(input.storage[10], equals(11.0));
  expect(input.storage[11], equals(12.0));

  expect(input.storage[12], equals(13.0));
  expect(input.storage[13], equals(14.0));
  expect(input.storage[14], equals(15.0));
  expect(input.storage[15], equals(16.0));
}

void testMatrix4InstacingFromByteBuffer() {
  final Float32List float32List = new Float32List.fromList([
    1.0,
    2.0,
    3.0,
    4.0,
    5.0,
    6.0,
    7.0,
    8.0,
    9.0,
    10.0,
    11.0,
    12.0,
    13.0,
    14.0,
    15.0,
    16.0,
    17.0
  ]);
  final ByteBuffer buffer = float32List.buffer;
  final Matrix4 zeroOffset = new Matrix4.fromBuffer(buffer, 0);
  final Matrix4 offsetVector =
      new Matrix4.fromBuffer(buffer, Float32List.BYTES_PER_ELEMENT);

  expect(zeroOffset.storage[0], equals(1.0));
  expect(zeroOffset.storage[1], equals(2.0));
  expect(zeroOffset.storage[2], equals(3.0));
  expect(zeroOffset.storage[3], equals(4.0));
  expect(zeroOffset.storage[4], equals(5.0));
  expect(zeroOffset.storage[5], equals(6.0));
  expect(zeroOffset.storage[6], equals(7.0));
  expect(zeroOffset.storage[7], equals(8.0));
  expect(zeroOffset.storage[8], equals(9.0));
  expect(zeroOffset.storage[9], equals(10.0));
  expect(zeroOffset.storage[10], equals(11.0));
  expect(zeroOffset.storage[11], equals(12.0));
  expect(zeroOffset.storage[12], equals(13.0));
  expect(zeroOffset.storage[13], equals(14.0));
  expect(zeroOffset.storage[14], equals(15.0));
  expect(zeroOffset.storage[15], equals(16.0));

  expect(offsetVector.storage[0], equals(2.0));
  expect(offsetVector.storage[1], equals(3.0));
  expect(offsetVector.storage[2], equals(4.0));
  expect(offsetVector.storage[3], equals(5.0));
  expect(offsetVector.storage[4], equals(6.0));
  expect(offsetVector.storage[5], equals(7.0));
  expect(offsetVector.storage[6], equals(8.0));
  expect(offsetVector.storage[7], equals(9.0));
  expect(offsetVector.storage[8], equals(10.0));
  expect(offsetVector.storage[9], equals(11.0));
  expect(offsetVector.storage[10], equals(12.0));
  expect(offsetVector.storage[11], equals(13.0));
  expect(offsetVector.storage[12], equals(14.0));
  expect(offsetVector.storage[13], equals(15.0));
  expect(offsetVector.storage[14], equals(16.0));
  expect(offsetVector.storage[15], equals(17.0));
}

void testMatrix4Transpose() {
  var inputA = new List();
  var expectedOutput = new List();
  inputA.add(parseMatrix(
      '''0.337719409821377   0.780252068321138   0.096454525168389   0.575208595078466
         0.900053846417662   0.389738836961253   0.131973292606335   0.059779542947156
         0.369246781120215   0.241691285913833   0.942050590775485   0.234779913372406
         0.111202755293787   0.403912145588115   0.956134540229802   0.353158571222071'''));
  expectedOutput.add(inputA[0].transposed());

  for (int i = 0; i < inputA.length; i++) {
    inputA[i].transpose();
    relativeTest(inputA[i], expectedOutput[i]);
  }
}

void testMatrix4VectorMultiplication() {
  var inputA = new List();
  var inputB = new List();
  var expectedOutput = new List();

  inputA.add(parseMatrix(
      '''0.337719409821377   0.780252068321138   0.096454525168389   0.575208595078466
         0.900053846417662   0.389738836961253   0.131973292606335   0.059779542947156
         0.369246781120215   0.241691285913833   0.942050590775485   0.234779913372406
         0.111202755293787   0.403912145588115   0.956134540229802   0.353158571222071'''));
  inputB.add(parseVector('''0.821194040197959
                            0.015403437651555
                            0.043023801657808
                            0.168990029462704'''));
  expectedOutput.add(parseVector('''0.390706088480722
                                    0.760902311900085
                                    0.387152194918898
                                    0.198357495624973'''));

  assert(inputA.length == inputB.length);
  assert(expectedOutput.length == inputB.length);

  for (int i = 0; i < inputA.length; i++) {
    var output = inputA[i] * inputB[i];
    relativeTest(output, expectedOutput[i]);
  }
}

void testMatrix4Multiplication() {
  var inputA = new List();
  var inputB = new List();
  var expectedOutput = new List();

  inputA.add(parseMatrix(
      '''0.587044704531417   0.230488160211558   0.170708047147859   0.923379642103244
   0.207742292733028   0.844308792695389   0.227664297816554   0.430207391329584
   0.301246330279491   0.194764289567049   0.435698684103899   0.184816320124136
   0.470923348517591   0.225921780972399   0.311102286650413   0.904880968679893'''));
  inputB.add(parseMatrix(
      '''0.979748378356085   0.408719846112552   0.711215780433683   0.318778301925882
   0.438869973126103   0.594896074008614   0.221746734017240   0.424166759713807
   0.111119223440599   0.262211747780845   0.117417650855806   0.507858284661118
   0.258064695912067   0.602843089382083   0.296675873218327   0.085515797090044'''));
  expectedOutput.add(parseMatrix(
      '''0.933571062150012   0.978468014433530   0.762614053950618   0.450561572247979
   0.710396171182635   0.906228190244263   0.489336274658484   0.576762187862375
   0.476730868989407   0.464650419830879   0.363428748133464   0.415721232510293
   0.828623949506267   0.953951612073692   0.690010785130483   0.481326146122225'''));

  assert(inputA.length == inputB.length);
  assert(expectedOutput.length == inputB.length);

  for (int i = 0; i < inputA.length; i++) {
    var output = inputA[i] * inputB[i];
    //print('${inputA[i].cols}x${inputA[i].rows} * ${inputB[i].cols}x${inputB[i].rows} = ${output.cols}x${output.rows}');
    relativeTest(output, expectedOutput[i]);
  }
}

void testMatrix4Adjoint() {
  var input = new List();
  var expectedOutput = new List();

  input.add(parseMatrix(
      '''0.934010684229183   0.011902069501241   0.311215042044805   0.262971284540144
         0.129906208473730   0.337122644398882   0.528533135506213   0.654079098476782
         0.568823660872193   0.162182308193243   0.165648729499781   0.689214503140008
         0.469390641058206   0.794284540683907   0.601981941401637   0.748151592823709'''));
  expectedOutput.add(parseMatrix(
      '''0.104914550911225  -0.120218628213523   0.026180662741638   0.044107217835411
        -0.081375770192194  -0.233925009984709  -0.022194776259965   0.253560794325371
         0.155967414263983   0.300399085119975  -0.261648453454468  -0.076412061081351
        -0.104925204524921   0.082065846290507   0.217666653572481  -0.077704028180558'''));
  input.add(parseMatrix('''1     0     0     0
                           0     1     0     0
                           0     0     1     0
                           0     0     0     1'''));
  expectedOutput.add(parseMatrix('''1     0     0     0
                                    0     1     0     0
                                    0     0     1     0
                                    0     0     0     1'''));

  input.add(parseMatrix(
      '''0.450541598502498   0.152378018969223   0.078175528753184   0.004634224134067
         0.083821377996933   0.825816977489547   0.442678269775446   0.774910464711502
         0.228976968716819   0.538342435260057   0.106652770180584   0.817303220653433
         0.913337361501670   0.996134716626885   0.961898080855054   0.868694705363510'''));
  expectedOutput.add(parseMatrix(
      '''-0.100386867815513   0.076681891597503  -0.049082198794982  -0.021689260610181
         -0.279454715225440  -0.269081505356250   0.114433412778961   0.133858687769130
          0.218879650360982   0.073892735462981   0.069073300555062  -0.132069899391626
          0.183633794399577   0.146113141160308  -0.156100829983306  -0.064859465665816'''));

  assert(input.length == expectedOutput.length);

  for (int i = 0; i < input.length; i++) {
    var output = input[i].clone();
    output.scaleAdjoint(1.0);
    relativeTest(output, expectedOutput[i]);
  }
}

void testMatrix4Determinant() {
  var input = new List();
  List<double> expectedOutput = new List<double>();
  input.add(parseMatrix(
      '''0.046171390631154   0.317099480060861   0.381558457093008   0.489764395788231
         0.097131781235848   0.950222048838355   0.765516788149002   0.445586200710899
         0.823457828327293   0.034446080502909   0.795199901137063   0.646313010111265
         0.694828622975817   0.438744359656398   0.186872604554379   0.709364830858073'''));
  expectedOutput.add(-0.199908980087990);

  input.add(parseMatrix(
      '''  -2.336158020850647   0.358791716162913   0.571930324052307   0.866477090273158
           -1.190335868711951   1.132044609886021  -0.693048859451418   0.742195189800671
            0.015919048685702   0.552417702663606   1.020805610524362  -1.288062497216858
            3.020318574990609  -1.197139524685751  -0.400475005629390   0.441263145991252'''));
  expectedOutput.add(-5.002276533849802);

  input.add(parseMatrix(
      '''0.934010684229183   0.011902069501241   0.311215042044805   0.262971284540144
         0.129906208473730   0.337122644398882   0.528533135506213   0.654079098476782
         0.568823660872193   0.162182308193243   0.165648729499781   0.689214503140008
         0.469390641058206   0.794284540683907   0.601981941401637   0.748151592823709'''));
  expectedOutput.add(0.117969860982876);
  assert(input.length == expectedOutput.length);

  for (int i = 0; i < input.length; i++) {
    double output = input[i].determinant();
    //print('${input[i].cols}x${input[i].rows} = $output');
    relativeTest(output, expectedOutput[i]);
  }
}

void testMatrix4SelfTransposeMultiply() {
  var inputA = new List();
  var inputB = new List();
  var expectedOutput = new List();

  inputA.add(parseMatrix(
      '''0.450541598502498   0.152378018969223   0.078175528753184   0.004634224134067
         0.083821377996933   0.825816977489547   0.442678269775446   0.774910464711502
         0.228976968716819   0.538342435260057   0.106652770180584   0.817303220653433
         0.913337361501670   0.996134716626885   0.961898080855054   0.868694705363510'''));
  inputB.add(parseMatrix(
      '''0.450541598502498   0.152378018969223   0.078175528753184   0.004634224134067
         0.083821377996933   0.825816977489547   0.442678269775446   0.774910464711502
         0.228976968716819   0.538342435260057   0.106652770180584   0.817303220653433
         0.913337361501670   0.996134716626885   0.961898080855054   0.868694705363510'''));
  expectedOutput.add(parseMatrix(
      '''1.096629343508065   1.170948826011164   0.975285713492989   1.047596917860438
         1.170948826011164   1.987289692246011   1.393079247172284   1.945966332001094
         0.975285713492989   1.393079247172284   1.138698195167051   1.266161729169725
         1.047596917860438   1.945966332001094   1.266161729169725   2.023122749969790'''));

  assert(inputA.length == inputB.length);
  assert(inputB.length == expectedOutput.length);

  for (int i = 0; i < inputA.length; i++) {
    var output = inputA[i].clone();
    output.transposeMultiply(inputB[i]);
    relativeTest(output, expectedOutput[i]);
  }
}

void testMatrix4SelfMultiply() {
  var inputA = new List();
  var inputB = new List();
  var expectedOutput = new List();

  inputA.add(parseMatrix(
      '''0.450541598502498   0.152378018969223   0.078175528753184   0.004634224134067
         0.083821377996933   0.825816977489547   0.442678269775446   0.774910464711502
         0.228976968716819   0.538342435260057   0.106652770180584   0.817303220653433
         0.913337361501670   0.996134716626885   0.961898080855054   0.868694705363510'''));
  inputB.add(parseMatrix(
      '''0.450541598502498   0.152378018969223   0.078175528753184   0.004634224134067
         0.083821377996933   0.825816977489547   0.442678269775446   0.774910464711502
         0.228976968716819   0.538342435260057   0.106652770180584   0.817303220653433
         0.913337361501670   0.996134716626885   0.961898080855054   0.868694705363510'''));
  expectedOutput.add(parseMatrix(
      '''0.237893273152584   0.241190507375353   0.115471053480014   0.188086069635435
         0.916103942227480   1.704973929800637   1.164721763902784   1.675285658272358
         0.919182849383279   1.351023203753565   1.053750106199745   1.215382950294249
         1.508657696357159   2.344965008135463   1.450552688877760   2.316940716769603'''));

  assert(inputA.length == inputB.length);
  assert(inputB.length == expectedOutput.length);

  for (int i = 0; i < inputA.length; i++) {
    var output = inputA[i].clone();
    output.multiply(inputB[i]);
    relativeTest(output, expectedOutput[i]);
  }
}

void testMatrix4SelfMultiplyTranspose() {
  var inputA = new List();
  var inputB = new List();
  var expectedOutput = new List();

  inputA.add(parseMatrix(
      '''0.450541598502498   0.152378018969223   0.078175528753184   0.004634224134067
         0.083821377996933   0.825816977489547   0.442678269775446   0.774910464711502
         0.228976968716819   0.538342435260057   0.106652770180584   0.817303220653433
         0.913337361501670   0.996134716626885   0.961898080855054   0.868694705363510'''));
  inputB.add(parseMatrix(
      '''0.450541598502498   0.152378018969223   0.078175528753184   0.004634224134067
         0.083821377996933   0.825816977489547   0.442678269775446   0.774910464711502
         0.228976968716819   0.538342435260057   0.106652770180584   0.817303220653433
         0.913337361501670   0.996134716626885   0.961898080855054   0.868694705363510'''));
  expectedOutput.add(parseMatrix(
      '''0.232339681975335   0.201799089276976   0.197320406329789   0.642508126615338
         0.201799089276976   1.485449982570056   1.144315170085286   1.998154153033270
         0.197320406329789   1.144315170085286   1.021602397682138   1.557970885061235
         0.642508126615338   1.998154153033270   1.557970885061235   3.506347918663387'''));

  assert(inputA.length == inputB.length);
  assert(inputB.length == expectedOutput.length);

  for (int i = 0; i < inputA.length; i++) {
    var output = inputA[i].clone();
    output.multiplyTranspose(inputB[i]);
    relativeTest(output, expectedOutput[i]);
  }
}

void testMatrix4Translation() {
  var inputA = new List();
  var inputB = new List();
  var output1 = new List();
  var output2 = new List();

  inputA.add(new Matrix4.identity());
  inputB.add(new Matrix4.translationValues(1.0, 3.0, 5.7));
  output1.add(inputA[0] * inputB[0]);
  output2.add((new Matrix4.identity())..translate(1.0, 3.0, 5.7));

  assert(inputA.length == inputB.length);
  assert(output1.length == output2.length);

  for (int i = 0; i < inputA.length; i++) {
    relativeTest(output1[i], output2[i]);
  }
}

void testMatrix4Scale() {
  var inputA = new List();
  var inputB = new List();
  var output1 = new List();
  var output2 = new List();

  inputA.add(new Matrix4.identity());
  inputB.add(new Matrix4.diagonal3Values(1.0, 3.0, 5.7));
  output1.add(inputA[0] * inputB[0]);
  output2.add(new Matrix4.identity()..scale(1.0, 3.0, 5.7));

  assert(inputA.length == inputB.length);
  assert(output1.length == output2.length);

  for (int i = 0; i < inputA.length; i++) {
    relativeTest(output1[i], output2[i]);
  }
}

void testMatrix4Rotate() {
  var output1 = new List();
  var output2 = new List();
  output1.add(new Matrix4.rotationX(1.57079632679));
  output2.add(new Matrix4.identity()..rotateX(1.57079632679));
  output1.add(new Matrix4.rotationY(1.57079632679 * 0.5));
  output2.add(new Matrix4.identity()..rotateY(1.57079632679 * 0.5));
  output1.add(new Matrix4.rotationZ(1.57079632679 * 0.25));
  output2.add(new Matrix4.identity()..rotateZ(1.57079632679 * 0.25));
  {
    var axis = new Vector3(1.1, 1.1, 1.1);
    axis.normalize();
    num angle = 1.5;

    Quaternion q = new Quaternion.axisAngle(axis, angle);
    Matrix3 R = q.asRotationMatrix();
    Matrix4 T = new Matrix4.identity();
    T.setRotation(R);
    output1.add(T);

    output2.add(new Matrix4.identity()..rotate(axis, angle));
  }
  assert(output1.length == output2.length);
  for (int i = 0; i < output1.length; i++) {
    relativeTest(output1[i], output2[i]);
  }
  return;
}

void testMatrix4GetRotation() {
  final mat4 = new Matrix4.rotationX(Math.PI) *
      new Matrix4.rotationY(-Math.PI) *
      new Matrix4.rotationZ(Math.PI);
  final mat3 = new Matrix3.rotationX(Math.PI) *
      new Matrix3.rotationY(-Math.PI) *
      new Matrix3.rotationZ(Math.PI);
  final matRot = mat4.getRotation();

  relativeTest(mat3, matRot);
}

void testMatrix4Column() {
  Matrix4 I = new Matrix4.zero();
  expect(I[0], 0.0);
  var c0 = new Vector4(1.0, 2.0, 3.0, 4.0);
  I.setColumn(0, c0);
  expect(I[0], 1.0);
  c0.x = 4.0;
  expect(I[0], 1.0);
  expect(c0.x, 4.0);
}

void testMatrix4Inversion() {
  Matrix4 m = new Matrix4(1.0, 0.0, 2.0, 2.0, 0.0, 2.0, 1.0, 0.0, 0.0, 1.0, 0.0,
      1.0, 1.0, 2.0, 1.0, 4.0);
  Matrix4 result = new Matrix4.zero();
  double det = result.copyInverse(m);
  expect(det, 2.0);
  expect(result.entry(0, 0), -2.0);
  expect(result.entry(1, 0), 1.0);
  expect(result.entry(2, 0), -8.0);
  expect(result.entry(3, 0), 3.0);
  expect(result.entry(0, 1), -0.5);
  expect(result.entry(1, 1), 0.5);
  expect(result.entry(2, 1), -1.0);
  expect(result.entry(3, 1), 0.5);
  expect(result.entry(0, 2), 1.0);
  expect(result.entry(1, 2), 0.0);
  expect(result.entry(2, 2), 2.0);
  expect(result.entry(3, 2), -1.0);
  expect(result.entry(0, 3), 0.5);
  expect(result.entry(1, 3), -0.5);
  expect(result.entry(2, 3), 2.0);
  expect(result.entry(3, 3), -0.5);
}

void testMatrix4Dot() {
  final Matrix4 matrix = new Matrix4(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0,
      9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0);

  final Vector4 v = new Vector4(1.0, 2.0, 3.0, 4.0);

  expect(matrix.dotRow(0, v), equals(90.0));
  expect(matrix.dotRow(1, v), equals(100.0));
  expect(matrix.dotRow(2, v), equals(110.0));
  expect(matrix.dotColumn(0, v), equals(30.0));
  expect(matrix.dotColumn(1, v), equals(70.0));
  expect(matrix.dotColumn(2, v), equals(110.0));
}

void testMatrix4PerspectiveTransform() {
  final matrix = makePerspectiveMatrix(Math.PI, 1.0, 1.0, 100.0);
  final vec = new Vector3(10.0, 20.0, 30.0);

  matrix.perspectiveTransform(vec);

  relativeTest(vec, new Vector3(0.0, 0.0, 1.087));
}

void testMatrix4Solving() {
  final Matrix4 A = new Matrix4(2.0, 12.0, 8.0, 8.0, 20.0, 24.0, 26.0, 4.0, 8.0,
      4.0, 60.0, 12.0, 16.0, 16.0, 14.0, 64.0);

  final Matrix3 A_small =
      new Matrix3(2.0, 12.0, 8.0, 20.0, 24.0, 26.0, 8.0, 4.0, 60.0);

  final Vector4 b = new Vector4(32.0, 64.0, 72.0, 8.0);
  final Vector4 result = new Vector4.zero();

  final Vector3 b3 = new Vector3(32.0, 64.0, 72.0);
  final Vector3 result3 = new Vector3.zero();

  final Vector2 b2 = new Vector2(32.0, 64.0);
  final Vector2 result2 = new Vector2.zero();

  Matrix4.solve(A, result, b);
  Matrix4.solve3(A, result3, b3);
  Matrix4.solve2(A, result2, b2);

  final Vector4 backwards = A.transform(new Vector4.copy(result));
  final Vector3 backwards3 = A.transform3(new Vector3.copy(result3));
  final Vector2 backwards2 = A_small.transform2(new Vector2.copy(result2));

  expect(backwards2.x, equals(b.x));
  expect(backwards2.y, equals(b.y));

  expect(backwards3.x, equals(b.x));
  expect(backwards3.y, equals(b.y));
  expect(backwards3.z, equals(b.z));

  expect(backwards.x, equals(b.x));
  expect(backwards.y, equals(b.y));
  expect(backwards.z, equals(b.z));
  expect(backwards.w, equals(b.w));
}

void testMatrix4Compose() {
  var tValues = [
    new Vector3.zero(),
    new Vector3(3.0, 0.0, 0.0),
    new Vector3(0.0, 4.0, 0.0),
    new Vector3(0.0, 0.0, 5.0),
    new Vector3(-6.0, 0.0, 0.0),
    new Vector3(0.0, -7.0, 0.0),
    new Vector3(0.0, 0.0, -8.0),
    new Vector3(-2.0, 5.0, -9.0),
    new Vector3(-2.0, -5.0, -9.0)
  ];

  var sValues = [
    new Vector3(1.0, 1.0, 1.0),
    new Vector3(2.0, 2.0, 2.0),
    new Vector3(1.0, -1.0, 1.0),
    new Vector3(-1.0, 1.0, 1.0),
    new Vector3(1.0, 1.0, -1.0),
    new Vector3(2.0, -2.0, 1.0),
    new Vector3(-1.0, 2.0, -2.0),
    new Vector3(-1.0, -1.0, -1.0),
    new Vector3(-2.0, -2.0, -2.0)
  ];

  var rValues = [
    new Quaternion.identity(),
    new Quaternion(0.42073549240394825, 0.42073549240394825,
        0.22984884706593015, 0.7701511529340699),
    new Quaternion(0.16751879124639693, -0.5709414713577319,
        0.16751879124639693, 0.7860666291368439),
    new Quaternion(0.0, 0.9238795292366128, 0.0, 0.38268342717215614)
  ];

  for (var ti = 0; ti < tValues.length; ti++) {
    for (var si = 0; si < sValues.length; si++) {
      for (var ri = 0; ri < rValues.length; ri++) {
        final t = tValues[ti];
        final s = sValues[si];
        final r = rValues[ri];

        final m = new Matrix4.compose(t, r, s);

        var t2 = new Vector3.zero();
        var r2 = new Quaternion.identity();
        var s2 = new Vector3.zero();

        m.decompose(t2, r2, s2);

        final m2 = new Matrix4.compose(t2, r2, s2);

        relativeTest(m2, m);
      }
    }
  }
}

void main() {
  group('Matrix4', () {
    test('instancing from Float32List', testMatrix4InstacingFromFloat32List);
    test('instancing from ByteBuffer', testMatrix4InstacingFromByteBuffer);
    test('Matrix transpose', testMatrix4Transpose);
    test('Determinant', testMatrix4Determinant);
    test('Adjoint', testMatrix4Adjoint);
    test('Self multiply', testMatrix4SelfMultiply);
    test('Self transpose', testMatrix4SelfTransposeMultiply);
    test('Self multiply tranpose', testMatrix4SelfMultiplyTranspose);
    test('Matrix multiplication', testMatrix4Multiplication);
    test('Matrix vector multiplication', testMatrix4VectorMultiplication);
    test('Matrix translate', testMatrix4Translation);
    test('Scale matrix', testMatrix4Scale);
    test('Rotate matrix', testMatrix4Rotate);
    test('Get rotation matrix', testMatrix4GetRotation);
    test('Set column', testMatrix4Column);
    test('inversion', testMatrix4Inversion);
    test('dot product', testMatrix4Dot);
    test('perspective transform', testMatrix4PerspectiveTransform);
    test('solving', testMatrix4Solving);
    test('compose/decompose', testMatrix4Compose);
  });
}
