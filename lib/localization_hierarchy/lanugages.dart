import 'package:get/get.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ar_EG': {
          'Language': 'اللغة',
          'mandatory field': 'لا يمكن ترك الحقل فارغ',
          'username': 'اسم المستخدم',
          'password': 'كلمة المرور',
          'Sign In': 'تسجيل الدخول',
          'Connection Error': 'خطأ في الاتصال',
          'Incorrect Credentials': 'بيانات الدخول غير صحيحة',
          'Sales': 'المبيعات',
          'Customers': 'العملاء',
          'Stock': 'المخزون',
          'Receipt Vouchers': 'سندات القبض',
          'Reports': 'التقارير',
          'Visits Plans': 'خطط الزيارات',
          'Home': 'الرئيسية',
          'View Invoices': 'عرض الفواتير',
          'Add Invoice': 'إضافة فاتورة',
          'View Customers': 'عرض العملاء',
          'Add Customer': 'إضافة عميل',
          'View Receipt Vouchers': 'عرض سندات القبض',
          'Add Receipt Voucher': 'إضافة سند قبض',
          'Show Products Stock': 'عرض مخزون المنتجات',
          'Show Visits Plan': 'عرض خطط الزيارات',
          'Sales Analysis': 'تحليل المبيعات',
          'Items Tree': 'شجرة الأصناف',
          'Choose Items Tree': 'اختر شجرة الأصناف',
          'Customers Balances': 'أرصدة العملاء',
          'Balance': 'الرصيد',
          'Customer Ledger': 'كشف حساب عميل',
          'No Transactions': 'لا توجد حركات',
          'Customers Information': 'بيانات العملاء',
          'Visits List': 'كشف الزيارات',
          'Customers Balance': 'أرصدة العملاء',
          'Stock Management': 'جرد مخزني',
          'Product History': 'حركة صنف',
          'Cash Balance': 'رصيد خزنة',
          'Cash Flow': 'حركة حساب الخزينة',
          'Settings & Privacy': 'إعدادات التطبيق',
          'Dark Mode': 'الوضع الداكن',
          'Edit App Connection Settings': 'تعديل إعدادات اتصال التطبيق',
          'Sales Settings': 'إعدادات المبيعات',
          'Sell Price Included VAT': 'سعر البيع شامل ضريبة القيمة المضافة',
          'Enable Customer Limit': 'تفعيل الحد الإئتماني للعملاء',
          'Add Taxable And Non Taxable Products In Sales':
              'إضافة منتجات ضريبية وغير ضريبية في البيع',
          'Following Up Invoices Payment': 'متابعة سداد الفواتير',
          'Date From': 'من تاريخ',
          'Date To': 'إلى تاريخ',
          'Enable Decimal Numbers': 'تفعيل الأرقام العشرية',
          'Payment Gateway Is Cash': 'طريقة الدفع نقدي',
          'Log Out': 'تسجيل خروج',
          "Need to configure your connection?": "لم تسجل اعدادات تطبيقك؟",
          'App Configuration': 'اعدادات التطبيق',
          'Save': 'حفظ',
          'API ADDRESS': 'رابط الخادم',
          'Service Key': 'مغتاح الخادم',
          'Unknown Server': 'خادم غير معرف',
          'Filter': 'تصفية',
          'Apply': 'تطبيق',
          'Choose A Customer': 'اختر عميل',
          'Price Range From': 'نطاق المبلغ من',
          'Price Range To': 'نطاق المبلغ إلى',
          'New': 'إضافة',
          'No Invoices Found.': 'لا توجد فواتير مسجلة.',
          'Invoice No: ': 'فاتورة رقم: ',
          'Date: ': 'تاريخ: ',
          'Customer Name: ': 'اسم العميل: ',
          'Price: ': 'السعر: ',
          'Date Error': 'خطأ بالتاريخ',
          'Server Response Error': 'خطأ في استجابة السيرفر',
          'Name': 'الاسم',
          'Phone': 'رقم الهاتف',
          'Address': 'العنوان',
          'Edit': 'تعديل',
          'New Invoice': 'فاتورة جديدة',
          'No Name': 'بدون اسم',
          'Cannot find customer': 'لا يمكن إيجاد العميل',
          'main quantity': 'كمية رئيسية',
          'sub quantity': 'كمية فرعية',
          'barcode': 'باركود',
          'failed to read': 'فشل القراءة',
          'Camera Inaccessible': 'لا يمكن الوصول للكاميرا',
          'We cannot access camera now, please try again':
              'لم نتمكن من الوصول للكاميرا الآن, حاول مرة أخرى',
          'Barcode Not Found': 'باركود غير موجود',
          'Main Unit': 'وحدة رئيسية',
          'Sub Unit': 'وحدة فرعية',
          'Small Unit': 'وحدة صغرى',
          'Quantity': 'الكمية',
          'ADD': 'إضافة',
          'Total': 'الإجمالي',
          'Total Tax:  ': 'إجمالي الضريبة:  ',
          'Total Discount:  ': 'إجمالي الخصم:  ',
          'Total:  ': 'الإجمالي:  ',
          'Visit Location:  ': 'موقع الزيارة:  ',
          'Item': 'الصنف',
          'Price': 'السعر',
          'Discount(%):': 'الخصم(٪)',
          'Tax(%):': 'الضريبة(٪)',
          'Delete': 'حذف',
          'Items in the invoice will be deleted as you change customer.\n Do you wish to proceed?':
              'سيتم حذف الأصناف عند تغيير العميل \n هل تريد الاستمرار؟',
          'Yes': 'نعم',
          'No': 'لا',
          'Note:  ': 'ملاحظات: ',
          'Print': 'طباعة',
          'Please add items before saving': 'يجب إضافة أصناف قبل الحفظ',
          'Unrecognized Location': 'موقع غير معرف',
          'Saved Successfully': 'تم الحفظ بنجاح',
          'Discount: ': 'الخصم: ',
          'Tax: ': 'الضريبة: ',
          'Are you sure?': 'هل أنت متأكد؟',
          'Do you want to leave without saving?': 'هل تريد الخروج دون الحفظ؟',
          'Discount': 'الخصم',
          'Tax': 'الضريبة',
          'User Unrecognized': 'مستخدم غير معروف',
          'Stock: ': 'المخزون: ',
          'Choose Customer': 'اختر عميل',
          'Choose Item': 'اختر صنف',
          'You must first choose a customer':
              'يجب تحديد العميل قبل اختيار الصنف',
          'Do you want to leave the app?': 'هل تريد مغادرة التطبيق؟',
          'Pay Type: ': 'طريقة الدفع: ',
          'Select pay type': 'اختر طريقة الدفع',
          'Cash': 'نقدًًا',
          'Receipt': 'سند قبض',
          'Credit': 'آجل',
          'New Customer': 'عميل جديد',
          'Location': 'الموقع',
          'Tax Code': 'الرقم الضريبي',
          'Customer Code': 'كود العميل',
          'Customer Name': 'اسم العميل',
          'Customer Code: ': 'كود العميل: ',
          'Error occurred, please contact support':
              'يوجد خطأ. من فضلك تواصل مع الدعم الفني',
          'Failed to get address': 'فشل الحصول على العنوان',
          'Could not find address': 'فشل الحصول على العنوان',
          'New Receipt': 'سند قبض جديد',
          'Error occurred, contact support': 'حدث خطأ, تواصل مع الدعم',
          'Amount: ': 'القيمة: ',
          'Note: ': 'بيان: ',
          'Doc No: ': 'رقم المستند: ',
          'No Notes': 'لا توجد ملاحظات',
          'Amount': 'القيمة',
          'Notes': 'ملاحظات',
          'No visits for the day': 'لا توجد زيارات جديدة',
          'vat included': 'السعر شامل الضريبة',
          'Save Receipt': 'حفظ السند',
          'Receipt Code: ': 'رقم السند: ',
          'Unit': 'الوحدة',
          'View Items Stock': 'عرض مخزون المنتجات',
          'Customers Reports': 'تقارير العملاء',
          'Sales Reports': 'تقارير المبيعات',
          'Cash Reports': 'تقارير الخزنة',
          'Products Reports': 'تقارير المنتجات',
          'No Sales Found': 'لا توجد مبيعات',
          'Pay Type:': 'طريقة الدفع:',
          'DEBIT': 'مدين',
          'CREDIT': 'دائن',
          'All': 'الكل',
          'You have to be within 500 meters range from client':
              'يجب أن تكون ضمن نطاق ٥٠٠ متر من العميل',
          'SN': 'م',
          'Note': 'بيان',
          'Routes': 'خط سير',
          'Returns': 'مرتجعات',
          'State: ': 'الحالة: ',
          'Notes: ': 'الملاحظات: ',
          'Item Discount': 'خصم الصنف',
          'Invoice Type': 'نوع الفاتورة',
          'Net Total': 'صافي الاجمالي',
          'VAT': 'ضريبة القيمة المضافة',
          'Negative Visit': 'زيارة سلبية',
          'Permission denied. Please enable storage permission.':
              'تم رفض الإذن. يرجى تمكين إذن التخزين.',
          'Purchase Order': 'أمر توريد',
          'Save & Print': 'حفظ وطباعة',
          'Proceed': 'نعم',
          'Cancel': 'لا',
          'Invoice': 'فاتورة',
          'Invoice pending acceptance, proceed to print PO?':
              'الفاتورة قيد الانتظار للموافقة، هل تريد طباعة أمر التوريد؟',
          'No Stock Items Found': 'لا توجد أصناف متاحة',
          'Total:': 'الإجمالي:',
          'Net Total:': 'الصافي:',
          'Tax:': 'الضريبة:',
          'Discount:': 'الخصم:',
          'Serial:': 'مسلسل الفاتورة:',
          'Date:': 'التاريخ:',
          'Customer Name:': 'اسم العميل:',
          'PO No:': 'رقم أمر التوريد:',
          'Invoice No:': 'رقم الفاتورة:',
          'Customer Code:': 'كود العميل:',
          'No host was found': 'اسم السيرفر خالي او غير صحيح',
          'Saved': 'تم الحفظ',
          'Item Name': 'اسم الصنف',
          'Invoice Date': 'تاريخ الفاتورة',
          'Serial': 'مسلسل',
          'Invoice Discount': 'اجمالي الخصم',
          'Choose Your Language': 'اختر لغتك',
          'agent': 'المندوب',
          'Date': 'التاريخ',
          'Customer': 'العميل',
          'Cash Flow Report': 'حركة حساب الخزينة',
        },
      };
}
