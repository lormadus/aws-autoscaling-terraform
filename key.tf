resource "aws_key_pair" "sshkey" {
  key_name   = "david-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDVKL5oqbTTpblxoPjunm7TjQWYmRc5mZkjC9gnMuCSdoSD2m1YJJ4y8Nk/+0xWnbMXmJxSub7Ti2mGp7hbTF31m+Wn9MebLdG826Qsfd9LQmcdmj7BsOpCH/o1vk+P71yJybTWqXfaEF9hYmCj0iPzhOFixo9rQwvnMSXEgKgtw5XB8Ic6M0+E1ehZGpQ3eeYF2R0mnUJ1OJsuWc3VYqfzE0M4vhtDCL7m6la280op8yGvKHUvkv7+K3n6eMK0J6vAQEaN62JTBJEDiYfdt1CjMkIhy860iv7wi7bWW0zRMR2aAFfNAx4ZzDc+8ILOUjFW1BuPJ5oxrnm0LlEF/guH ec2-user@ip-172-31-20-214"
}

### SSH 접속을 위한 RSA-KEY 생성
## 리눅스 서버 혹은 Cloud9에서
## ssh-keygen 실행
## <Enter> 키를 세번 누릅니다
## 홈디렉토리의 .ssh 디렉토리로 가시면 id_rsa(프라이빗 키), id_rsa.pub(퍼브릭키 - AWS 에 등록할 키) 가 생성됩니다.
