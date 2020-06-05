#키 페어 설정
resource "aws_key_pair" "user10-terraform-key" {
  key_name   = var.keyName # var에서 keyName에 AWS에 등록될 키페어 명칭 수정
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  lifecycle {
    ignore_changes = [tags]
  }
}