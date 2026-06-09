import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

class CompanionPolicyPrivacy extends StatelessWidget {
  const CompanionPolicyPrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: 'ເງື່ອນໄຂ ແລະ ນະໂຍບາຍ',
        subtitle: 'ຜູ້ໃຫ້ບໍລິການ',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            SizedBox(height: 20.h),
            _intro(),
            SizedBox(height: 20.h),
            _whatIsXaosao(),
            SizedBox(height: 20.h),
            _sectionI(),
            SizedBox(height: 20.h),
            _sectionII(),
            SizedBox(height: 20.h),
            _sectionIII(),
            SizedBox(height: 20.h),
            _sectionIV(),
            SizedBox(height: 20.h),
            _sectionV(),
            SizedBox(height: 28.h),
            _divider(),
            SizedBox(height: 20.h),
            _privacyPolicy(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _header() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ເງື່ອນໄຂ ແລະ ນະໂຍບາຍຄວາມເປັນສ່ວນຕົວ\nຂອງຜູ້ໃຫ້ບໍລິການ',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryVariant,
              height: 1.5,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'ອັບເດດ 30/03/2026',
            style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
          ),
        ],
      );

  Widget _intro() => _bodyText(
        'ກ່ອນທີ່ທ່ານຈະເລີ່ມໃຊ້ງານ Xaosao ໃນຖານະ ຜູ້ໃຫ້ບໍລິການ, ກະລຸນາອ່ານ ເງື່ອນໄຂ ແລະ ນະໂຍບາຍ ນີ້ຢ່າງລະອຽດ ເພາະວ່ານີ້ຄືສັນຍາທາງກົດໝາຍລະຫວ່າງທ່ານ ແລະ ທີມງານ Xaosao. ການທີ່ທ່ານຍອມຮັບ ເງື່ອນໄຂ ແລະ ນະໂຍບາຍ ນີ້ຖືວ່າທ່ານໄດ້ຮັບຮູ້ ແລະ ຕົກລົງກ່ຽວກັບຂໍ້ກໍານົດທີ່ໄດ້ກ່າວໄວ້ທັງໝົດ.\n\nXaosao ເປັນພຽງ ຕົວກາງ ໃນການຊ່ວຍເຊື່ອມຕໍ່ລະຫວ່າງ ຜູ້ໃຫ້ບໍລິການ ແລະ ຜູ້ໃຊ້ບໍລິການ ໂດຍ Xaosao ຈະບໍ່ຮັບຜິດຊອບຕໍ່ກັບການກະທໍາໃດໜຶ່ງ ຫລື ພຶດຕິກໍາທີ່ເກີດຂຶ້ນ ລະຫວ່າງ ຜູ້ໃຫ້ບໍລິການ ແລະ ຜູ້ໃຊ້ບໍລິການ ໃນທຸກກໍລະນີ.',
      );

  Widget _whatIsXaosao() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Xaosao ເຮັດກ່ຽວກັບຫຍັງ?'),
          SizedBox(height: 10.h),
          _bullet('ເປັນ Application ສໍາລັບຜູ້ທີ່ຕ້ອງການຫາເພື່ອນ, ຄູ່ເດັດ, ຄູ່ເດີນທາງ ຫລື ຄູ່ນວດ ໂດຍຜ່ານລະບົບ Xaosao'),
          _bullet('ມີລະບົບຈອງທີ່ຍືດຫຍຸ່ນ ສາມາດຈອງໄດ້ທັງ ຍິງ ແລະ ຊາຍ ຕາມຄວາມຕ້ອງການ'),
          _bullet('Xaosao ບໍ່ແມ່ນ Platform ຊື້-ຂາຍ ຫລື ທຸລະກໍາທາງການຄ້າໃດໆ'),
        ],
      );

  Widget _sectionI() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('I. ການສະໝັກເຂົ້າໃຊ້ງານ'),
          SizedBox(height: 10.h),
          _numbered(1, 'ຜູ້ສະໝັກຕ້ອງມີອາຍຸ 18 ປີຂຶ້ນໄປ'),
          _numbered(2, 'ການສະໝັກ ແລະ ຈົດທະບຽນ ສາມາດເຮັດໄດ້ຟຣີ ໂດຍບໍ່ມີຄ່າໃຊ້ຈ່າຍ'),
          _numbered(3, 'ຂໍ້ມູນ ແລະ ຮູບພາບທີ່ທ່ານໃສ່ ຕ້ອງເປັນຂໍ້ມູນ ແລະ ຮູບພາບຂອງທ່ານເອງ'),
          _numbered(4, 'ການສະໝັກ ແລະ ໃຫ້ບໍລິການ ເປັນໄປຕາມຄວາມສະໝັກໃຈຂອງທ່ານ ໂດຍທ່ານຈະບໍ່ຖືກບັງຄັບໃດໆ'),
          _numbered(5, 'ທ່ານມີສິດ ເລືອກໃຫ້ ຫລື ປະຕິເສດ ການໃຫ້ບໍລິການໄດ້'),
          _numbered(6, 'ທ່ານຕ້ອງມີຈັນຍາບັນທາງດ້ານວິຊາຊີບ ຫາກທ່ານຮັບ Booking ໃດໜຶ່ງໄປແລ້ວ ແຕ່ບໍ່ສາມາດໄປໄດ້ ທ່ານຕ້ອງແຈ້ງໃຫ້ຜູ້ໃຊ້ບໍລິການຊາບລ່ວງໜ້າ'),
          _numbered(7, 'ທ່ານສາມາດສ້າງໄດ້ 2 ບັນຊີ ໃນ 1 ເບີໂທ ຄື ບັນຊີຜູ້ໃຫ້ບໍລິການ 1 ບັນຊີ ແລະ ບັນຊີຜູ້ໃຊ້ 1 ບັນຊີ'),
          _numbered(8, 'ທ່ານໄດ້ອະນຸຍາດໃຫ້ລະບົບ ເຂົ້າເຖິງ ຂໍ້ມູນ, ກ້ອງຖ່າຍຮູບ, ຕໍາແໜ່ງທີ່ຢູ່ ຂອງທ່ານ'),
          _numbered(9, 'Xaosao ຂໍສະຫງວນສິດໃນການດັດແກ້ ຫລື ປ່ຽນແປງ ນະໂຍບາຍ ຫລື ເງື່ອນໄຂ ໄດ້ຕາມຄວາມເໝາະສົມ'),
          _numbered(10, 'Xaosao ຈະໃຊ້ເວລາ 3 ວັນທໍາການ ໃນການກວດສອບ ແລະ ຢັ້ງຢືນ ໂປຣໄຟລ໌ ຂອງທ່ານ'),
        ],
      );

  Widget _sectionII() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('II. ຂໍ້ຫ້າມ'),
          SizedBox(height: 10.h),
          _numbered(1, 'ຫ້າມໂພສຮູບທີ່ ລາມົກ, ອະນາຈານ ໃນທຸກຮູບແບບ'),
          _numbered(2, 'ຫ້າມໃຊ້ຄໍາເວົ້າ ຫລື ພາສາ ທີ່ບໍ່ເໝາະສົມ ທີ່ຈະດູຖູກ ຫລື ສ້ອງຜູ້ອື່ນ'),
          _numbered(3, 'ຫ້າມຊື້-ຂາຍ ຫລື ດໍາເນີນທຸລະກໍາ ທີ່ຜິດກົດໝາຍຂອງ ສປປ ລາວ ທຸກຮູບແບບ'),
          _numbered(4, 'ຫ້າມ ສໍ້ໂກງ, ໂກງ, ແຕ່ງຕັ້ງຕົນເອງ ຫລື ສວມຮອຍ ໂດຍໃຊ້ຂໍ້ມູນ ຫລື ຮູບພາບຂອງຜູ້ອື່ນ'),
        ],
      );

  Widget _sectionIII() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('III. ການແກ້ໄຂຂໍ້ຂັດແຍ້ງ'),
          SizedBox(height: 10.h),
          _numbered(1, 'ຄູ່ກໍລະນີຕ້ອງຍື່ນຫຼັກຖານ ພາຍໃນ 15 ວັນທໍາການ ນັບຈາກວັນທີ່ເກີດຂໍ້ຂັດແຍ້ງ'),
          _numbered(2, 'ລະບົບ Xaosao ຈະດໍາເນີນການກວດສອບ ຫຼັກຖານ ທີ່ໄດ້ຮັບ'),
          _numbered(3, 'ທີມງານ Xaosao ຈະເຂົ້າມາໄກ່ເກ່ຍ ໃຫ້ທັງສອງຝ່າຍ'),
          _numbered(4, 'ທັງສອງຝ່າຍ ຕ້ອງໃຫ້ຄວາມຮ່ວມມື ໃນການແກ້ໄຂ ແລະ ສົ່ງຂໍ້ມູນ'),
          _numbered(5, 'ຫາກຄູ່ກໍລະນີຝ່າຍໃດ ບໍ່ພໍໃຈ ສາມາດຍື່ນຟ້ອງຕໍ່ ໜ່ວຍງານທີ່ກ່ຽວຂ້ອງ ຫລື ຕາມກົດໝາຍ ສປປ ລາວ ຕໍ່ໄປ'),
          _numbered(6, 'ລະບົບ Xaosao ຈະຮັບຜິດຊອບ ພາຍໃນຂອບເຂດທີ່ກໍານົດໄວ້ໃນນະໂຍບາຍນີ້ເທົ່ານັ້ນ'),
        ],
      );

  Widget _sectionIV() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('IV. ການປິດ/ລຶບບັນຊີ'),
          SizedBox(height: 10.h),
          _numbered(1, 'ທ່ານສາມາດ ລຶບບັນຊີ ຂອງທ່ານດ້ວຍຕົນເອງ ໂດຍໃນ 30 ວັນ ທ່ານສາມາດ ກູ້ຄືນ ໄດ້'),
          _numbered(2, 'ກ່ອນທີ່ລະບົບຈະ ລຶບຖາວອນ ທາງລະບົບ Xaosao ຈະ ແຈ້ງ ທ່ານ ຜ່ານ Email ຫລື ເບີໂທ 7 ວັນ ລ່ວງໜ້າ'),
          _numbered(3, 'ຫາກທ່ານ ບໍ່ໄດ້ OpenApp ໃນໄລຍະ 3 ເດືອນ ທາງລະບົບຈະ ແຈ້ງ ທ່ານ ໃນ 15 ວັນ ກ່ອນທີ່ຈະລຶບ'),
          _numbered(4, 'ຫາກທ່ານ ສໍ້ໂກງ ຫລື ກະທໍາໃດໆ ທີ່ຜິດ ກົດ-ລະບຽບ ໃນ ນະໂຍບາຍ Xaosao ທາງທີມງານຈະ ລະງັບ ຫລື ປິດ ບັນຊີ ຂອງທ່ານ'),
          _numbered(5, 'ກ່ອນທີ່ຈະ ລຶບ ຫລື ປິດ ບັນຊີ ທ່ານຕ້ອງໄດ້ ຖອນເງິນ ອອກກ່ອນ'),
          _numbered(6, 'ຫາກໄດ້ຮັບການ Approved ແຕ່ ບໍ່ໄດ້ Open Service ໃດໆ ພາຍໃນ 7 ວັນ → ປິດ ພາຍໃນ 30 ວັນ → ລຶບຖາວອນ'),
        ],
      );

  Widget _sectionV() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('V. ຜົນປະໂຫຍດ'),
          SizedBox(height: 10.h),
          _numbered(1, 'ທ່ານຈະໄດ້ຮັບລາຍໄດ້ ຈາກການຈອງໃຊ້ບໍລິການ'),
          _numbered(2, 'ທ່ານຈະໄດ້ຮັບ Commission ຕາມ Tier ທີ່ໄດ້ກໍານົດ'),
          _numbered(3, 'ທ່ານຈະໄດ້ຮັບ ໂປຣໂມຊັ່ນ ຕ່າງໆ ຈາກ Platform Xaosao'),
          _numbered(4, 'ທ່ານຈະໄດ້ ສ້າງເຄືອຂ່າຍສັງຄົມ ແລະ ຮູ້ຈັກຄົນໃໝ່ໆ'),
          SizedBox(height: 8.h),
          _note('ໝາຍເຫດ: ບໍ່ມີຂັ້ນຕ່ຳໃນການຖອນເງິນ ແລະ ທ່ານສາມາດກວດສອບຍອດເງິນ ໄດ້ທຸກເວລາ'),
        ],
      );

  Widget _privacyPolicy() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _mainTitle('ນະໂຍບາຍຄວາມເປັນສ່ວນຕົວ'),
          SizedBox(height: 6.h),
          Text(
            'ອັບເດດ 30/03/2026',
            style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
          ),
          SizedBox(height: 14.h),
          _bodyText(
            'ນະໂຍບາຍຄວາມເປັນສ່ວນຕົວສະບັບນີ້ ໄດ້ຮັບການຮ່າງຂຶ້ນ ໂດຍ ບໍລິສັດ ໂອກາດເທັກ ຈໍາກັດ ອ້າງອີງຕາມ ກົດໝາຍວ່າດ້ວຍການປົກປ້ອງຂໍ້ມູນເອເລັກໂທຣນິກ ສະບັບເລກທີ 25/ສພຊ ວັນທີ 12 ພຶດສະພາ 2017 ແລະ ໄດ້ຈັດພິມໄວ້ສໍາລັບ Application Xaosao ໂດຍສະເພາະ.',
          ),
          SizedBox(height: 16.h),
          _subSectionTitle('ຄໍານິຍາມ'),
          SizedBox(height: 8.h),
          _defItem('ກົດໝາຍ', 'ກົດໝາຍວ່າດ້ວຍການປົກປ້ອງຂໍ້ມູນສ່ວນຕົວ ສະບັບເລກທີ 25/ສພຊ'),
          _defItem('ນະໂຍບາຍ', 'ນະໂຍບາຍຄວາມເປັນສ່ວນຕົວສະບັບນີ້'),
          _defItem('ບັນຊີ', 'ບັນຊີທີ່ຖືກສ້າງຂຶ້ນສໍາລັບທ່ານ ເພື່ອເຂົ້າເຖິງ Application ຫລື ສ່ວນຕ່າງໆຂອງ Application ຂອງພວກເຮົາ'),
          _defItem('Application', 'ໝາຍເຖິງ ເຊົ່າສາວ ທີ່ດາວໂຫລດໄດ້ໃນ iOS ຫລື Android'),
          _defItem('ອຸປະກອນ', 'ໝາຍເຖິງ ອຸປະກອນໃດໆ ທີ່ສາມາດເຂົ້າເຖິງ Application ໄດ້'),
          _defItem('ລະບົບ', 'ໝາຍເຖິງ xaosao'),
          _defItem('ຂໍ້ມູນສ່ວນຕົວ', 'ຂໍ້ມູນໃດໆ ທີ່ກ່ຽວຂ້ອງ ກັບບຸກຄົນທີ່ລະບຸຕົວໄດ້ ຫລື ລະບຸຕົວໄດ້'),
          _defItem('ການບໍລິການ', 'ໝາຍເຖິງ Application'),
          _defItem('ຜູ້ໃຊ້', 'ຜູ້ທີ່ ຈ່າຍ ໃຫ້ Xaosao ເພື່ອຫາ ຜູ້ໃຫ້ບໍລິການ'),
          _defItem('ຜູ້ໃຫ້', 'ຜູ້ທີ່ ເຮັດວຽກ ກັບ Xaosao ແລະ ໄດ້ຮັບລາຍໄດ້ ຈາກ Xaosao'),
          _defItem('ຂໍ້ມູນການນຳໃຊ້', 'ຂໍ້ມູນທີ່ລວບລວມໂດຍອັດຕະໂນມັດ ຕາມການນຳໃຊ້ Application'),
          _defItem('ທ່ານ', 'ໝາຍເຖິງ ບຸກຄົນ ທີ່ກໍາລັງເຂົ້າໃຊ້ ຫລື ໃຊ້ Application'),
          _defItem('ຂໍ້ຕົກລົງ', 'ໝາຍເຖິງ ເງື່ອນໄຂ ຕ່າງໆ'),
          _defItem('ພາກສ່ວນທີສາມ', 'ໝາຍເຖິງ ບຸກຄົນ ຫລື ທຸລະກິດ ອື່ນໆ ນອກຈາກ ທ່ານ ຫລື ບໍລິສັດ'),
          _defItem('ສະໝັກບັນຊີ', 'ໝາຍເຖິງ ການສ້າງ ຫລື ສະໝັກ ບັນຊີ ທີ່ Xaosao'),
          _defItem('ການປະມວນຜົນຂໍ້ມູນສ່ວນບຸກຄົນ', 'ໝາຍເຖິງ ການດໍາເນີນການໃດໆ ກ່ຽວກັບຂໍ້ມູນສ່ວນຕົວ'),
          SizedBox(height: 16.h),
          _subSectionTitle('ການເກັບກໍາຂໍ້ມູນ'),
          SizedBox(height: 8.h),
          _bodyText('Xaosao ເກັບກໍາຂໍ້ມູນ ຜ່ານທາງ ເບີໂທລະສັບ, Email, Facebook ຫລື Google ຂອງທ່ານ'),
          SizedBox(height: 10.h),
          _bodyText('ປະເພດຂໍ້ມູນທີ່ເກັບກໍາ:'),
          SizedBox(height: 6.h),
          _bullet('ຂໍ້ມູນຕົວຕົນ: ຮູບພາບ, ຊື່, ນາມສະກຸນ, ອາຍຸ, ວັນ ເດືອນ ປີ ເກີດ'),
          _bullet('ຂໍ້ມູນຕິດຕໍ່: ທີ່ຢູ່, ເບີໂທ, Email'),
          _bullet('ຂໍ້ມູນບັນຊີ Xaosao'),
          _bullet('ຂໍ້ມູນຢັ້ງຢືນຕົວຕົນ: ເບີໂທລະສັບ (ຕ້ອງການ)'),
          _bullet('ຂໍ້ມູນທຸລະກໍາ/ການເງິນ: ລະຫັດ QR ທະນາຄານ, ປະຫວັດລາຍໄດ້, ການຖອນເງິນ, ຄ່ານາຍໜ້າ'),
          SizedBox(height: 16.h),
          _subSectionTitle('ຈຸດປະສົງໃນການປະມວນຜົນຂໍ້ມູນ'),
          SizedBox(height: 8.h),
          _numbered(1, 'ສ້າງ ແລະ ຈັດການ ບັນຊີ ຂອງທ່ານ'),
          _numbered(2, 'ຊໍາລະ ຄ່າບໍລິການ'),
          _numbered(3, 'ສະໜັບສະໜູນ ຫລັງການໃຊ້ງານ'),
          _numbered(4, 'ເກັບກໍາ ຄໍາຕິຊົມ'),
          _numbered(5, 'ປະຕິບັດຕາມ ເງື່ອນໄຂ Xaosao'),
          _numbered(6, 'ຂໍ ຄວາມຍິນຍອມ ຈາກທ່ານ'),
          _numbered(7, 'ແຈ້ງ ຈຸດປະສົງ ໃນການໃຊ້ຂໍ້ມູນ'),
          _numbered(8, 'ແຈ້ງ ເວລາ ທີ່ຕ້ອງການຂໍ້ມູນສ່ວນຕົວ'),
          _numbered(9, 'ແຈ້ງ ປະເພດຂໍ້ມູນ ທີ່ຈໍາເປັນ ແລະ ໄລຍະເວລາເກັບຮັກສາ'),
          _numbered(10, 'ແຈ້ງ ພາກສ່ວນທີ່ຈະໄດ້ຮັບຂໍ້ມູນ'),
          _numbered(11, 'ແຈ້ງ ສິດທາງກົດໝາຍ ຂອງທ່ານ'),
          SizedBox(height: 16.h),
          _subSectionTitle('ສິດຂອງເຈົ້າຂອງຂໍ້ມູນ'),
          SizedBox(height: 8.h),
          _numbered(1, 'ສິດ ຖອນຄວາມຍິນຍອມ — ທ່ານສາມາດຖອນຄວາມຍິນຍອມ ໃນການໃຊ້ຂໍ້ມູນສ່ວນຕົວຂອງທ່ານ ໄດ້ທຸກເວລາ'),
          _numbered(2, 'ສິດ ເຂົ້າເຖິງ/ຂໍສໍາເນົາ — ທ່ານມີສິດ ຂໍ ແລະ ໄດ້ຮັບ ສໍາເນົາຂໍ້ມູນສ່ວນຕົວ ທີ່ Xaosao ເກັບໄວ້'),
          _numbered(3, 'ສິດ ໂອນຍ້າຍ/ສົ່ງຕໍ່ຂໍ້ມູນ — ທ່ານມີສິດ ຂໍ ໃຫ້ Xaosao ສົ່ງຂໍ້ມູນ ຂອງທ່ານ ໄປຫາ ຜູ້ຄຸ້ມຄອງຂໍ້ມູນ ອື່ນ'),
          _numbered(4, 'ສິດ ແກ້ໄຂ — ທ່ານມີສິດ ໃຫ້ Xaosao ແກ້ໄຂ ຂໍ້ມູນ ທີ່ບໍ່ຖືກຕ້ອງ ຫລື ຂໍ້ມູນ ທີ່ ບໍ່ຄົບຖ້ວນ'),
          _numbered(5, 'ສິດ ຄັດຄ້ານ — ທ່ານມີສິດ ຄັດຄ້ານ ການປະມວນຜົນຂໍ້ມູນ ໃນກໍລະນີ ດໍາເນີນການ ໂດຍ ອໍານາດ ສາທາລະນະ / ຜົນປະໂຫຍດສາທາລະນະ, ດ້ານ ການຕະຫລາດ ໂດຍກົງ ຕ່ໍາ, ດ້ານ ການຄົ້ນຄວ້າ ຫລື ສະຖິຕິ'),
          _numbered(6, 'ສິດ ລຶບ/ທໍາລາຍ — ທ່ານມີສິດ ຂໍ ໃຫ້ Xaosao ລຶບ ຫລື ທໍາລາຍ ຂໍ້ມູນ ສ່ວນຕົວຂອງທ່ານ'),
          _numbered(7, 'ສິດ ຈໍາກັດ ການປະມວນຜົນ — ທ່ານມີສິດ ຂໍ ໃຫ້ Xaosao ຈໍາກັດ ການໃຊ້ຂໍ້ມູນ ສ່ວນຕົວຂອງທ່ານ'),
          _numbered(8, 'ສິດ ຮ້ອງຮຽນ — ທ່ານມີສິດ ຮ້ອງຮຽນ ຕໍ່ ໜ່ວຍງານ ທີ່ກ່ຽວຂ້ອງ ກ່ຽວກັບ ການໃຊ້ຂໍ້ມູນ ສ່ວນຕົວຂອງທ່ານ'),
          SizedBox(height: 12.h),
          _bodyText('ໄລຍະເວລາດໍາເນີນການ:'),
          SizedBox(height: 6.h),
          _bullet('ດ້ວຍຕົວທ່ານເອງ ຜ່ານ Website Xaosao: 7 ວັນ'),
          _bullet('ເຂົ້າເຖິງ/ສໍາເນົາ: ທັນທີ'),
          _bullet('ໂອນຍ້າຍ: 30 ວັນ'),
          _bullet('ແກ້ໄຂ: ທັນທີ'),
          _bullet('ຄັດຄ້ານ: 30 ວັນ'),
          _bullet('ລຶບ: 30 ວັນ'),
          _bullet('ຈໍາກັດ: 30 ວັນ'),
          SizedBox(height: 16.h),
          _subSectionTitle('Cookies'),
          SizedBox(height: 8.h),
          _bodyText(
            'Xaosao ໃຊ້ Cookies ແລະ ເຕັກໂນໂລຢີ ທີ່ຄ້າຍຄືກັນ ເພື່ອຕິດຕາມ ກິດຈະກໍາ ໃນ Application ຂອງພວກເຮົາ ແລະ ເກັບຮັກສາ ຂໍ້ມູນ ບາງຢ່າງ. ທ່ານສາມາດ ຕັ້ງຄ່າ ອຸປະກອນ ຂອງທ່ານ ໃຫ້ ປະຕິເສດ Cookies ທັງໝົດ ຫລື ໃຫ້ ສັນຍານ ເມື່ອ Cookies ຖືກສົ່ງ.',
          ),
          SizedBox(height: 16.h),
          _subSectionTitle('ຄວາມປອດໄພຂອງຂໍ້ມູນ'),
          SizedBox(height: 8.h),
          _bodyText(
            'ຄວາມປອດໄພ ຂອງຂໍ້ມູນ ສ່ວນຕົວ ຂອງທ່ານ ມີຄວາມສໍາຄັນ ສໍາລັບ Xaosao ແຕ່ຈົ່ງຈໍາໄວ້ວ່າ ວິທີການ ສົ່ງຂໍ້ມູນ ຜ່ານ Internet ຫລື ວິທີ ການເກັບຮັກສາ ທາງ ອີເລັກໂທຣນິກ ບໍ່ມີ ວິທີໃດ ທີ່ ປອດໄພ 100%. ເຖິງວ່າ Xaosao ຈະ ພະຍາຍາມ ໃຊ້ວິທີ ທີ່ ຍອມຮັບ ໃນ ການຄຸ້ມຄອງ ຂໍ້ມູນ ສ່ວນຕົວ ຂອງທ່ານ ແຕ່ Xaosao ຈະ ບໍ່ ສາມາດ ຮັບປະກັນ ຄວາມ ປອດໄພ ໂດຍ ສົມບູນ ໄດ້.',
          ),
          SizedBox(height: 16.h),
          _subSectionTitle('ການລາຍງານ ຄວາມລະເມີດ'),
          SizedBox(height: 8.h),
          _bodyText(
            'ໃນກໍລະນີ ທີ່ Xaosao ກວດສອບ ແລ້ວ ວ່າ ຂໍ້ມູນ ຖືກລະເມີດ ທີ່ ສ້າງ ຜົນກະທົບ ຕໍ່ ສິດທິ ແລະ ຄວາມເສລີ ຂອງ ທ່ານ, Xaosao ຈະ ດໍາເນີນ ການ ແຈ້ງ ໜ່ວຍງານ ຄຸ້ມຄອງ ທີ່ ກ່ຽວຂ້ອງ ພາຍໃນ 72 ຊົ່ວໂມງ.',
          ),
          SizedBox(height: 16.h),
          _subSectionTitle('ລິ້ງ ໄປຫາ ເວັບໄຊ ອື່ນ'),
          SizedBox(height: 8.h),
          _bodyText(
            'Application ຂອງ Xaosao ອາດຈະ ມີ ລິ້ງ ໄປຫາ ເວັບໄຊ ອື່ນ ທີ່ ບໍ່ ໄດ້ ດໍາເນີນການ ໂດຍ Xaosao. ຖ້າ ທ່ານ ຄລິກ ລິ້ງ ຂອງ ພາກສ່ວນ ທີສາມ ທ່ານ ຈະ ຖືກ ນໍາໄປ ຫາ ເວັບໄຊ ຂອງ ພາກສ່ວນ ທີສາມ ນັ້ນ. Xaosao ແນະນໍາ ຢ່າງ ຍິ່ງ ໃຫ້ ທ່ານ ກວດເບິ່ງ ນະໂຍບາຍ ຄວາມ ເປັນ ສ່ວນຕົວ ຂອງ ທຸກໆ ເວັບໄຊ ທີ່ ທ່ານ ໄປ ຢ້ຽມຢາມ.',
          ),
          SizedBox(height: 16.h),
          _subSectionTitle('ການ ປ່ຽນແປງ ນະໂຍບາຍ ຄວາມ ເປັນ ສ່ວນຕົວ'),
          SizedBox(height: 8.h),
          _bodyText(
            'Xaosao ອາດ ຈະ ອັບເດດ ນະໂຍບາຍ ຄວາມ ເປັນ ສ່ວນຕົວ ຂອງ Xaosao ເປັນ ບາງ ໂອກາດ. Xaosao ຈະ ແຈ້ງ ທ່ານ ກ່ຽວກັບ ການ ປ່ຽນແປງ ໃດໆ ໂດຍ ການ ຕີພິມ ນະໂຍບາຍ ຄວາມ ເປັນ ສ່ວນຕົວ ໃໝ່ ລົງ ໃນ ໜ້ານີ້.',
          ),
          SizedBox(height: 16.h),
          _subSectionTitle('ຕິດຕໍ່'),
          SizedBox(height: 8.h),
          _bullet('Email: xaosao95@gmail.com'),
          _bullet('ເບີໂທ: 2091082600'),
          _bullet('WhatsApp: 2091082600'),
        ],
      );

  // ── helpers ──────────────────────────────────────────────────

  Widget _mainTitle(String t) => Text(
        t,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.primaryVariant,
        ),
      );

  Widget _sectionTitle(String t) => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8.r),
          border: Border(
            left: BorderSide(color: AppColors.primary, width: 3),
          ),
        ),
        child: Text(
          t,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryVariant,
          ),
        ),
      );

  Widget _subSectionTitle(String t) => Text(
        t,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryVariant,
        ),
      );

  Widget _bodyText(String t) => Text(
        t,
        style: TextStyle(
          fontSize: 13.sp,
          color: AppColors.textSecondary,
          height: 1.7,
        ),
      );

  Widget _bullet(String t) => Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 6.h, right: 8.w),
              child: Container(
                width: 5.r,
                height: 5.r,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Expanded(
              child: Text(
                t,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _numbered(int n, String t) => Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 22.r,
              height: 22.r,
              margin: EdgeInsets.only(top: 1.h, right: 10.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$n',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                t,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _defItem(String term, String def) => Padding(
        padding: EdgeInsets.only(bottom: 7.h),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '• $term: ',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryVariant,
                ),
              ),
              TextSpan(
                text: def,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _note(String t) => Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          t,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
            height: 1.6,
          ),
        ),
      );

  Widget _divider() => Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.withValues(alpha: 0.3))),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              'ນະໂຍບາຍຄວາມເປັນສ່ວນຕົວ',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textHint,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey.withValues(alpha: 0.3))),
        ],
      );
}
