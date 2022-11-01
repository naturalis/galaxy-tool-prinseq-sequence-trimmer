# galaxy-tool-prinseq-sequence-trimmer
trim/filter on length/quality or use to convert fastq to fasta.  

## Installation  
### Manual  
Clone this repo in your Galaxy ***Tools*** directory:  
`git clone https://github.com/naturalis/galaxy-tool-prinseq-sequence-trimmer`  

Make sure the script is executable:  
`chmod 755 galaxy-tool-prinseq-sequence-trimmer/prinseq.sh`  

Append the file ***tool_conf.xml***:  
`<tool file="/path/to/Tools/ggalaxy-tool-prinseq-sequence-trimmer/prinseq.xml" />`  

### Ansible
Depending on your setup the [ansible.builtin.git](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/git_module.html) module could be used.  
[Install the tool](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/git_module.html#examples) by including the following in your dedicated ***.yml** file:  

`  - repo: https://github.com/naturalis/galaxy-tool-prinseq-sequence-trimmer`  
&ensp;&ensp;`file: prinseq.xml`  
&ensp;&ensp;`version: master`  
