-- task2 Hiển thị thông tin của tất cả nhân viên có trong hệ thống có tên bắt đầu là một trong các ký tự “H”, “T” hoặc “K” và có tối đa 15 kí tự.
select * from nhan_vien
where  (ho_ten like "H%" or ho_ten like "T%" or ho_ten like "K%") and (length(ho_ten)<=15);

-- task3 Hiển thị thông tin của tất cả khách hàng có độ tuổi từ 18 đến 50 tuổi và có địa chỉ ở “Đà Nẵng” hoặc “Quảng Trị”.
select * from khach_hang
where (round(datediff(curdate(), ngay_sinh)/365,0) <=50)
and (round(datediff(curdate(), ngay_sinh)/365,0) >= 18)
and (dia_chi like "%Đà Nẵng" or dia_chi like "%Quảng Trị");

--  task4 Đếm xem tương ứng với mỗi khách hàng đã từng đặt phòng bao nhiêu lần. Kết quả hiển thị được sắp xếp tăng dần theo số lần đặt phòng của khách hàng. Chỉ đếm những khách hàng nào có Tên loại khách hàng là “Diamond”.
select khach_hang.ma_khach_hang, khach_hang.ho_ten, count(*) so_lan_dat_phong
from khach_hang
join hop_dong  on hop_dong.ma_khach_hang=khach_hang.ma_khach_hang
join loai_khach on loai_khach.ma_loai_khach = khach_hang.ma_loai_khach
where loai_khach.ma_loai_khach =1
group by khach_hang.ma_khach_hang
order by so_lan_dat_phong asc;

/*task5:Hiển thị ma_khach_hang, ho_ten, ten_loai_khach, ma_hop_dong, ten_dich_vu, ngay_lam_hop_dong, ngay_ket_thuc, tong_tien 
(Với tổng tiền được tính theo công thức như sau: Chi Phí Thuê + Số Lượng * Giá, với Số Lượng và Giá là từ bảng dich_vu_di_kem, hop_dong_chi_tiet) 
cho tất cả các khách hàng đã từng đặt phòng. (những khách hàng nào chưa từng đặt phòng cũng phải hiển thị ra).*/
select kh.ma_khach_hang, kh.ho_ten, lk.ten_loai_khach,
 hd.ma_hop_dong,dv.ten_dich_vu, hd.ngay_lam_hop_dong, hd.ngay_ket_thuc,
sum(ifnull(dv.chi_phi_thue,0) + ifnull(dvdk.gia,0)* ifnull(hdct.so_luong,0) ) as tong_tien
from khach_hang kh
left join loai_khach as lk on kh.ma_loai_khach=lk.ma_loai_khach
left join hop_dong as hd on kh.ma_khach_hang=hd.ma_khach_hang
left join dich_vu as dv on hd.ma_dich_vu=dv.ma_dich_vu
left join hop_dong_chi_tiet as hdct on hd.ma_hop_dong=hdct.ma_hop_dong
left join dich_vu_di_kem as dvdk on hdct.ma_dich_vu_di_kem=dvdk.ma_dich_vu_di_kem
group by hd.ma_hop_dong;

/*task6 Hiển thị ma_dich_vu, ten_dich_vu, dien_tich, chi_phi_thue, ten_loai_dich_vu của tất cả các loại
 dịch vụ chưa từng được khách hàng thực hiện đặt trong quý 1 của năm 2021 (Quý 1 là tháng 1, 2, 3).*/
 
 select dv.ma_dich_vu, dv.ten_dich_vu, dv.dien_tich, dv.chi_phi_thue, ldv.ten_loai_dich_vu
 from dich_vu as dv
 join loai_dich_vu as ldv on dv.ma_loai_dich_vu=ldv.ma_loai_dich_vu
 join hop_dong as hd on dv.ma_dich_vu=hd.ma_dich_vu
 where dv.ma_dich_vu not in (
 select dv.ma_dich_vu
 from dich_vu as dv
 join loai_dich_vu as ldv on dv.ma_loai_dich_vu=ldv.ma_loai_dich_vu
 join hop_dong as hd on dv.ma_dich_vu=hd.ma_dich_vu
 where  year(hd.ngay_lam_hop_dong) =2021 and quarter(hd.ngay_lam_hop_dong) =1
 and dv.ma_dich_vu  in (
 select dv.ma_dich_vu
 from dich_vu as dv
 join loai_dich_vu as ldv on dv.ma_loai_dich_vu=ldv.ma_loai_dich_vu
 join hop_dong as hd on dv.ma_dich_vu=hd.ma_dich_vu
 where  year(hd.ngay_lam_hop_dong) =2020 or year(hd.ngay_lam_hop_dong) =2021 or quarter(hd.ngay_lam_hop_dong) in (2,3,4)
))
group by dv.ma_dich_vu
;
 
 /*task7	Hiển thị thông tin ma_dich_vu, ten_dich_vu, dien_tich, so_nguoi_toi_da, chi_phi_thue, ten_loai_dich_vu của tất cả các loại dịch vụ đã từng 
 được khách hàng đặt phòng trong năm 2020 nhưng chưa từng được khách hàng đặt phòng trong năm 2021.*/
 
 select dv.ma_dich_vu, dv.ten_dich_vu, dv.dien_tich, dv.so_nguoi_toi_da, dv.chi_phi_thue, ldv.ten_loai_dich_vu
 from dich_vu as dv
 join loai_dich_vu as ldv on dv.ma_loai_dich_vu=ldv.ma_loai_dich_vu
 where dv.ma_dich_vu not in (select dv.ma_dich_vu
 from dich_vu as dv
 join loai_dich_vu as ldv on dv.ma_loai_dich_vu=ldv.ma_loai_dich_vu
 join hop_dong as hd on dv.ma_dich_vu=hd.ma_dich_vu
 where hd.ngay_lam_hop_dong  like "2021%")
;

-- task8 hiển thị ho_ten khách hàng không trùng nhau
-- cách 1
SELECT distinct ho_ten
FROM khach_hang;

-- cách 2
select  ho_ten
from khach_hang
union
select  ho_ten
from khach_hang;

-- cách3
select ho_ten
from khach_hang
group by ho_ten;

-- task9 Thực hiện thống kê doanh thu theo tháng, nghĩa là tương ứng với mỗi tháng trong năm 2021 
-- thì sẽ có bao nhiêu khách hàng thực hiện đặt phòng.

select month(hd.ngay_lam_hop_dong) thang, count(*) 
from hop_dong as hd
where hd.ngay_lam_hop_dong not like "2020%"
group by thang
order by thang;

-- task10 Hiển thị thông tin tương ứng với từng hợp đồng thì đã sử dụng bao nhiêu dịch vụ đi kèm.
--  Kết quả hiển thị bao gồm ma_hop_dong, ngay_lam_hop_dong, ngay_ket_thuc, tien_dat_coc, so_luong_dich_vu_di_kem 
--  (được tính dựa trên việc sum so_luong ở dich_vu_di_kem).
select hd.ma_hop_dong, hd.ngay_lam_hop_dong, hd.ngay_ket_thuc, hd.tien_dat_coc,
sum(ifnull(hdct.so_luong,0)) so_luong_dich_vu_di_kem
from hop_dong as hd
left join hop_dong_chi_tiet as hdct on hd.ma_hop_dong=hdct.ma_hop_dong
group by hd.ma_hop_dong;

-- task11 Hiển thị thông tin các dịch vụ đi kèm đã được sử dụng bởi những khách hàng có ten_loai_khach là “Diamond”
--  và có dia_chi ở “Vinh” hoặc “Quảng Ngãi”.
select dvdk.ma_dich_vu_di_kem, dvdk.ten_dich_vu_di_kem
from dich_vu_di_kem as dvdk
join hop_dong_chi_tiet as hdct on dvdk.ma_dich_vu_di_kem=hdct.ma_dich_vu_di_kem
join hop_dong as hd on hdct.ma_hop_dong=hd.ma_hop_dong
join khach_hang as kh on hd.ma_khach_hang=kh.ma_khach_hang
join loai_khach as lk on kh.ma_loai_khach=lk.ma_loai_khach
where lk.ten_loai_khach like "Diamond" and (kh.dia_chi like "%Vinh%" or kh.dia_chi like "%Quảng Ngãi%");

-- task12 Hiển thị thông tin ma_hop_dong, ho_ten (nhân viên), ho_ten (khách hàng), so_dien_thoai (khách hàng), ten_dich_vu, so_luong_dich_vu_di_kem (được tính dựa trên việc sum so_luong ở dich_vu_di_kem),
--  tien_dat_coc của tất cả các dịch vụ đã từng được khách hàng đặt vào 3 tháng cuối năm 2020 nhưng
--  chưa từng được khách hàng đặt vào 6 tháng đầu năm 2021.
select hd.ma_hop_dong, nv.ho_ten, kh.ho_ten, kh.so_dien_thoai, dv.ma_dich_vu, dv.ten_dich_vu,
sum(ifnull(hdct.so_luong,0)) so_luong_dich_vu_di_kem, hd.tien_dat_coc
from khach_hang as kh
join hop_dong as hd on hd.ma_khach_hang=kh.ma_khach_hang
join nhan_vien as nv on hd.ma_nhan_vien=nv.ma_nhan_vien
join dich_vu as dv on hd.ma_dich_vu=dv.ma_dich_vu
left join hop_dong_chi_tiet as hdct on hd.ma_hop_dong=hdct.ma_hop_dong
left join dich_vu_di_kem as dvdk on hdct.ma_dich_vu_di_kem=dvdk.ma_dich_vu_di_kem
where kh.ma_khach_hang in( 
select kh.ma_khach_hang
from khach_hang as kh
join hop_dong as hd on kh.ma_khach_hang=hd.ma_khach_hang
 where (year(hd.ngay_lam_hop_dong) = 2020) and month(hd.ngay_lam_hop_dong) in (10,11,12)
or (year(hd.ngay_lam_hop_dong) = 2021 and quarter(hd.ngay_lam_hop_dong) in (3,4))
and kh.ma_khach_hang not in (
select kh.ma_khach_hang
from khach_hang as kh
join hop_dong as hd on kh.ma_khach_hang=hd.ma_khach_hang
 where (year(hd.ngay_lam_hop_dong) = 2020) and quarter(hd.ngay_lam_hop_dong) in (1,2,3)
or (year(hd.ngay_lam_hop_dong) = 2021 and quarter(hd.ngay_lam_hop_dong) in (1,2))
)
)
group by hd.ma_hop_dong;
 
 -- task13	Hiển thị thông tin các Dịch vụ đi kèm được sử dụng nhiều nhất bởi các Khách hàng đã đặt phòng.
--  (Lưu ý là có thể có nhiều dịch vụ có số lần sử dụng nhiều như nhau).
select dvdk.ma_dich_vu_di_kem,dvdk.ten_dich_vu_di_kem ,(( sum(hdct.so_luong))) as so_lan_su_dung
from dich_vu_di_kem as dvdk
join hop_dong_chi_tiet as hdct on dvdk.ma_dich_vu_di_kem=hdct.ma_dich_vu_di_kem
group by hdct.ma_dich_vu_di_kem
having so_lan_su_dung >= all(select so_luong from hop_dong_chi_tiet);

-- task14 Hiển thị thông tin tất cả các Dịch vụ đi kèm chỉ mới được sử dụng một lần duy nhất.
--  Thông tin hiển thị bao gồm ma_hop_dong, ten_loai_dich_vu, ten_dich_vu_di_kem, so_lan_su_dung
--  (được tính dựa trên việc count các ma_dich_vu_di_kem).
select hd.ma_hop_dong, ldv.ten_loai_dich_vu, dvdk.ten_dich_vu_di_kem, count(hdct.ma_dich_vu_di_kem) as so_lan_su_dung 
from hop_dong as hd
join dich_vu as dv on hd.ma_dich_vu=dv.ma_dich_vu
join loai_dich_vu as ldv on dv.ma_loai_dich_vu=ldv.ma_loai_dich_vu
join hop_dong_chi_tiet as hdct on hd.ma_hop_dong=hdct.ma_hop_dong
join dich_vu_di_kem as dvdk on hdct.ma_dich_vu_di_kem=dvdk.ma_dich_vu_di_kem
group by hdct.ma_dich_vu_di_kem
having so_lan_su_dung =1;

-- task15 Hiển thi thông tin của tất cả nhân viên bao gồm ma_nhan_vien, ho_ten, ten_trinh_do, ten_bo_phan, so_dien_thoai, dia_chi
--  mới chỉ lập được tối đa 3 hợp đồng từ năm 2020 đến 2021.
select nv.ma_nhan_vien, nv.ho_ten, td.ten_trinh_do, bp.ten_bo_phan, nv.so_dien_thoai,
nv.dia_chi,hd.ngay_lam_hop_dong
from nhan_vien as nv
join trinh_do as td on nv.ma_trinh_do=td.ma_trinh_do
join bo_phan as bp on nv.ma_bo_phan=bp.ma_bo_phan
join hop_dong as hd on nv.ma_nhan_vien=hd.ma_nhan_vien 
where year(hd.ngay_lam_hop_dong) between 2020 and 2021
group by hd.ma_nhan_vien
having count(hd.ma_nhan_vien) <=3
;

-- task16 Xóa những Nhân viên chưa từng lập được hợp đồng nào từ năm 2019 đến năm 2021.
delete from nhan_vien
where ma_nhan_vien not in(
select tabl.col from(
select nv.ma_nhan_vien as col
from nhan_vien as nv
left join hop_dong hd on nv.ma_nhan_vien=hd.ma_nhan_vien
where (year(hd.ngay_lam_hop_dong) in (2019,2021))
) as tabl
);

-- task17 Cập nhật thông tin những khách hàng có ten_loai_khach từ Platinum lên Diamond, chỉ cập nhật những khách hàng đã từng đặt
--  phòng với Tổng Tiền thanh toán trong năm 2021 là lớn hơn 10.000.000 VNĐ.
update khach_hang
set ten_loai_khach = 'Diamond' and ma_loai_khach=1
where ma_loai_khach =2 and ma_loai_khach in (
select tabl.col from(
select lk.ma_loai_khach as col
from loai_khach as lk
join khach_hang as kh on lk.ma_loai_khach=kh.ma_loai_khach
join hop_dong as hd on hd.ma_khach_hang=kh.ma_khach_hang
join dich_vu as dv on hd.ma_dich_vu=dv.ma_dich_vu
join hop_dong_chi_tiet as hdct on hd.ma_hop_dong=hdct.ma_hop_dong
join dich_vu_di_kem as dvdk on hdct.ma_dich_vu_di_kem=dvdk.ma_dich_vu_di_kem
having sum(dv.chi_phi_thue+ hdct.so_luong*dvdk.gia) >10000000
)as tabl
);

-- task18 Xóa những khách hàng có hợp đồng trước năm 2021 (chú ý ràng buộc giữa các bảng).
SET FOREIGN_KEY_CHECKS = 0;
delete from khach_hang
where ma_khach_hang not in (
select tabl.col from(
select kh.ma_khach_hang as col
from khach_hang as kh
left join hop_dong hd on kh.ma_khach_hang=hd.ma_nhan_vien
where (year(hd.ngay_lam_hop_dong) between 2019 and 2021)
) as tabl
);

-- insert into  khach_hang
-- value
-- (1,'Nguyễn Thị Hào','1970-11-07',b'0','643431213','0945423362','thihao07@gmail.com','23 Nguyễn Hoàng, Đà Nẵng',5),
-- (4,'Dương Văn Quan','1981-07-08',b'1','543432111','0490039241','duongquan@gmail.com','K453/12 Lê Lợi, Đà Nẵng',1),
-- (5,'Hoàng Trần Nhi Nhi','1995-12-09',b'0','795453345','0312345678','nhinhi123@gmail.com','224 Lý Thái Tổ, Gia Lai',4),
-- (6,'Tôn Nữ Mộc Châu','2005-12-06',b'0','732434215','0988888844','tonnuchau@gmail.com','37 Yên Thế, Đà Nẵng',4),
-- (8,'Nguyễn Thị Hào','1999-04-08',b'0','965656433','0763212345','haohao99@gmail.com','55 Nguyễn Văn Linh, Kon Tum',3),
-- (9,'Trần Đại Danh','1994-07-01',b'1','432341235','0643343433','danhhai99@gmail.com','24 Lý Thường Kiệt, Quảng Ngãi',1);	


-- task19 Cập nhật giá cho các dịch vụ đi kèm được sử dụng trên 10 lần trong năm 2020 lên gấp đôi.
update  dich_vu_di_kem as dvdk
set gia= gia *2
where ma_dich_vu_di_kem in (
select tabl.col from(
select dvdk.ma_dich_vu_di_kem as col
from dich_vu_di_kem as dvdk
join hop_dong_chi_tiet as hdct on dvdk.ma_dich_vu_di_kem=hdct.ma_dich_vu_di_kem
join hop_dong as hd on hdct.ma_hop_dong=hd.ma_hop_dong
where (hdct.so_luong >10) and  (year(hd.ngay_lam_hop_dong) =2020)
)as tabl
);

-- task20 Hiển thị thông tin của tất cả các nhân viên và khách hàng có trong hệ thống, thông tin hiển thị bao gồm id (ma_nhan_vien, ma_khach_hang)
-- , ho_ten, email, so_dien_thoai, ngay_sinh, dia_chi.
select ma_nhan_vien id, ho_ten, email, so_dien_thoai, ngay_sinh, dia_chi
from nhan_vien
union
select ma_khach_hang, ho_ten, email, so_dien_thoai, ngay_sinh, dia_chi
from khach_hang;

-- Câu 21:
-- Tạo khung nhìn có tên là v_nhan_vien để lấy được thông tin của tất cả các nhân viên có địa chỉ là “Hải Châu” 
-- và đã từng lập hợp đồng cho một hoặc nhiều khách hàng bất kì với ngày lập hợp đồng là “12/12/2019”.

CREATE VIEW v_nhan_vien AS
SELECT nhan_vien.*
FROM nhan_vien
LEFT JOIN hop_dong ON hop_dong.ma_nhan_vien = nhan_vien.ma_nhan_vien
WHERE nhan_vien.dia_chi REGEXP 'Đà Nẵng'
HAVING count(hop_dong.ma_hop_dong) >= 1; -- (Nối bảng)

-- Câu 22:
-- Thông qua khung nhìn v_nhan_vien thực hiện cập nhật địa chỉ thành “Liên Chiểu” đối với tất cả các nhân viên được nhìn thấy bởi khung nhìn này.
UPDATE v_nhan_vien
SET dia_chi = 'Liên Chiểu';

-- Câu 23:
-- Tạo Stored Procedure sp_xoa_khach_hang dùng để xóa thông tin của một khách hàng nào đó với ma_khach_hang được truyền vào như là 1 tham số của sp_xoa_khach_hang.
DELIMITER //
CREATE PROCEDURE sp_xoa_khach_hang (ma_khach_hang_xoa int)
BEGIN
	SET FOREIGN_KEY_CHECKS = 0;
	DELETE FROM khach_hang
    WHERE ma_khach_hang = ma_khach_hang_xoa;
END
// DELIMITER ;

CALL sp_xoa_khach_hang(2);